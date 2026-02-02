#!/bin/bash
set -e

echo "🎙️  VoiceInk Monitor - Starting 15s capture..."
echo "Start your recording NOW!"
echo ""

OUTPUT_FILE="voiceink-debug-$(date +%Y%m%d-%H%M%S).log"

{
  echo "=== TIMESTAMP: $(date) ==="
  echo ""

  # Monitor system logs for VoiceInk in background
  echo "📋 System Logs:"
  timeout 15s log stream --predicate 'process == "VoiceInk"' --level info 2>&1 &
  LOG_PID=$!

  # Monitor file system activity for VoiceInk
  echo ""
  echo "📁 File System Activity:"
  sudo fs_usage -w -f filesys VoiceInk 2>&1 | head -100 &
  FS_PID=$!

  # Monitor process stats every 0.5s
  echo ""
  echo "📊 Process Stats (every 0.5s):"
  for i in {1..30}; do
    echo "[$i/30] $(date +%H:%M:%S.%N | cut -c1-12) - $(ps -p $(pgrep VoiceInk) -o %cpu,%mem,rss 2>/dev/null || echo 'not running')"
    sleep 0.5
  done &
  STATS_PID=$!

  # Monitor audio device state
  echo ""
  echo "🔊 Audio Device Changes:"
  log stream --predicate 'subsystem == "com.apple.audio"' --level info 2>&1 | head -20 &
  AUDIO_PID=$!

  # Wait for monitoring to complete
  wait $LOG_PID $FS_PID $STATS_PID $AUDIO_PID 2>/dev/null

  echo ""
  echo "=== CAPTURE COMPLETE ==="
  echo "Timestamp: $(date)"

} 2>&1 | tee "$OUTPUT_FILE"

echo ""
echo "✅ Saved to: $OUTPUT_FILE"
echo ""
echo "Look for patterns around the 3.2s mark!"
