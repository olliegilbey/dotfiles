#!/usr/bin/env python3
"""
mitmproxy addon to monitor Spotify traffic and flag DJ-related requests
Usage: mitmproxy --mode transparent -s spotify_dj_monitor.py
"""

import json
import re
from mitmproxy import http
from datetime import datetime


class SpotifyDJMonitor:
    def __init__(self):
        self.spotify_hosts = [
            'api.spotify.com',
            'spclient.wg.spotify.com',
            'gew1-spclient.spotify.com',
            'guc3-spclient.spotify.com',
            'gae2-spclient.spotify.com',
            'open.spotify.com',
            'accounts.spotify.com',
            'audio-fa.scdn.co',
            'audio-fad.scdn.co',
            'dealer.spotify.com',
            'apresolve.spotify.com'
        ]
        
        self.dj_keywords = [
            'dj', 'queue', 'mix', 'playlist', 'radio',
            'shuffle', 'crossfade', 'transition', 'fade',
            'autoplay', 'smart_shuffle', 'enhance',
            'recommendations', 'seed', 'blend'
        ]
        
        self.interesting_endpoints = [
            '/v1/me/player',
            '/connect-state',
            '/queue',
            '/recommendations',
            '/radio',
            '/enhance',
            '/dj',
            '/smart-shuffle'
        ]

    def is_spotify_request(self, flow: http.HTTPFlow) -> bool:
        """Check if the request is to a Spotify domain"""
        return any(host in flow.request.pretty_host.lower() for host in self.spotify_hosts)

    def is_dj_related(self, flow: http.HTTPFlow) -> bool:
        """Check if the request appears to be DJ-related"""
        # Check URL path
        url = flow.request.pretty_url.lower()
        if any(keyword in url for keyword in self.dj_keywords):
            return True
            
        # Check for interesting endpoints
        if any(endpoint in url for endpoint in self.interesting_endpoints):
            return True
            
        # Check request body if it exists
        if flow.request.content:
            try:
                content = flow.request.get_text().lower()
                if any(keyword in content for keyword in self.dj_keywords):
                    return True
            except:
                pass
                
        return False

    def log_request(self, flow: http.HTTPFlow, is_dj_related: bool = False):
        """Log the request details"""
        timestamp = datetime.now().strftime("%H:%M:%S")
        method = flow.request.method
        url = flow.request.pretty_url
        
        prefix = "🎧 DJ RELATED" if is_dj_related else "🎵 Spotify"
        print(f"\n[{timestamp}] {prefix}")
        print(f"  {method} {url}")
        
        # Show headers that might be interesting
        interesting_headers = ['authorization', 'x-spotify-token', 'user-agent']
        for header in interesting_headers:
            if header in flow.request.headers:
                value = flow.request.headers[header]
                if header == 'authorization' and value:
                    # Truncate auth tokens for security
                    value = value[:20] + "..." if len(value) > 20 else value
                print(f"  {header.title()}: {value}")
        
        # Show request body for DJ-related requests
        if is_dj_related and flow.request.content:
            try:
                content = flow.request.get_text()
                if content:
                    print(f"  Request Body: {content[:200]}{'...' if len(content) > 200 else ''}")
            except:
                print(f"  Request Body: <binary data, {len(flow.request.content)} bytes>")

    def request(self, flow: http.HTTPFlow) -> None:
        """Called when a request is made"""
        if not self.is_spotify_request(flow):
            return
            
        is_dj = self.is_dj_related(flow)
        self.log_request(flow, is_dj)

    def response(self, flow: http.HTTPFlow) -> None:
        """Called when a response is received"""
        if not self.is_spotify_request(flow):
            return
            
        if self.is_dj_related(flow):
            print(f"  Response: {flow.response.status_code}")
            
            # Try to parse and show response for DJ-related requests
            if flow.response.content:
                try:
                    content = flow.response.get_text()
                    if content and flow.response.headers.get("content-type", "").startswith("application/json"):
                        # Pretty print JSON response (truncated)
                        try:
                            json_data = json.loads(content)
                            json_str = json.dumps(json_data, indent=2)
                            print(f"  Response Body: {json_str[:500]}{'...' if len(json_str) > 500 else ''}")
                        except:
                            print(f"  Response Body: {content[:300]}{'...' if len(content) > 300 else ''}")
                    else:
                        print(f"  Response Body: {content[:200]}{'...' if len(content) > 200 else ''}")
                except:
                    print(f"  Response Body: <binary data, {len(flow.response.content)} bytes>")


# Create the addon instance
addons = [SpotifyDJMonitor()]
