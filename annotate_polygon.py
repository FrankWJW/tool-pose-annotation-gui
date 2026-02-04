import json
import os
from pathlib import Path
from typing import Any, Dict, List, Optional


def _load_pairs(pairs_path: str) -> List[Dict[str, Any]]:
    with open(pairs_path, "r", encoding="utf-8") as pairs_file:
        return json.load(pairs_file)


def open_biopsy_video(
    index: int,
    pairs_path: str = "pairs.json",
    video_root: Optional[str] = None,
) -> str:
    """Return the resolved biopsy video path for a given pair index."""
    pairs = _load_pairs(pairs_path)
    if index < 0 or index >= len(pairs):
        raise IndexError(f"Pair index {index} is out of range for {pairs_path}.")

    video_path = pairs[index].get("video")
    if not video_path:
        raise KeyError(f"Missing 'video' entry for index {index} in {pairs_path}.")

    if video_root:
        return str(Path(video_root) / video_path)

    return os.fspath(Path(video_path))
