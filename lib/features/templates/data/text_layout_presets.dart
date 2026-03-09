// Text layout presets for the invitation canvas editor.
//
// Canvas reference size: 360 × 600 (portrait).
// Safe full-width zone: x=20, width=320.

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

/// A single text block within a preset layout.
class TextLayoutItem {
  const TextLayoutItem({
    required this.label,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.defaultText,
  });

  /// Human-readable role of this text block (e.g. "Title", "Date").
  final String label;

  final double x;
  final double y;
  final double width;
  final double height;
  final double fontSize;

  /// Placeholder text shown when the preset is first applied.
  final String defaultText;
}

/// A named collection of [TextLayoutItem]s that form a coherent layout.
class TextLayoutPreset {
  const TextLayoutPreset({
    required this.id,
    required this.name,
    required this.description,
    required this.items,
    this.isPro = false,
  });

  final String id;
  final String name;
  final String description;
  final List<TextLayoutItem> items;
  final bool isPro;
}

// ---------------------------------------------------------------------------
// Preset definitions
// ---------------------------------------------------------------------------

/// All built-in text layout presets available in the editor.
const List<TextLayoutPreset> textLayoutPresets = [
  // 1. Title Only ────────────────────────────────────────────────────────────
  TextLayoutPreset(
    id: 'title_only',
    name: 'Title Only',
    description: 'A single large centered title — ideal for a bold statement.',
    items: [
      TextLayoutItem(
        label: 'Title',
        x: 20,
        y: 240,
        width: 320,
        height: 60,
        fontSize: 36,
        defaultText: 'Your Title Here',
      ),
    ],
  ),

  // 2. Title + Subtitle ──────────────────────────────────────────────────────
  TextLayoutPreset(
    id: 'title_subtitle',
    name: 'Title + Subtitle',
    description: 'Large title with a smaller subtitle directly beneath it.',
    items: [
      TextLayoutItem(
        label: 'Title',
        x: 20,
        y: 200,
        width: 320,
        height: 60,
        fontSize: 34,
        defaultText: 'Main Title',
      ),
      TextLayoutItem(
        label: 'Subtitle',
        x: 20,
        y: 276,
        width: 320,
        height: 36,
        fontSize: 18,
        defaultText: 'A short subtitle or tagline',
      ),
    ],
  ),

  // 3. Title + Body ──────────────────────────────────────────────────────────
  TextLayoutPreset(
    id: 'title_body',
    name: 'Title + Body',
    description: 'Eye-catching title followed by a multi-line body paragraph.',
    items: [
      TextLayoutItem(
        label: 'Title',
        x: 20,
        y: 120,
        width: 320,
        height: 56,
        fontSize: 30,
        defaultText: 'Event Title',
      ),
      TextLayoutItem(
        label: 'Body',
        x: 20,
        y: 196,
        width: 320,
        height: 120,
        fontSize: 15,
        defaultText:
            'Join us for a special occasion filled with joy and celebration. '
            'We look forward to sharing this memorable moment with you.',
      ),
    ],
  ),

  // 4. Header + Name + Details ───────────────────────────────────────────────
  TextLayoutPreset(
    id: 'header_name_details',
    name: 'Header + Name + Details',
    isPro: true,
    description:
        'Classic invitation layout: header line, prominent name, then date / time / venue details.',
    items: [
      TextLayoutItem(
        label: 'Header',
        x: 20,
        y: 80,
        width: 320,
        height: 36,
        fontSize: 16,
        defaultText: 'You Are Cordially Invited',
      ),
      TextLayoutItem(
        label: 'Name',
        x: 20,
        y: 136,
        width: 320,
        height: 60,
        fontSize: 32,
        defaultText: 'Full Name',
      ),
      TextLayoutItem(
        label: 'Date',
        x: 20,
        y: 220,
        width: 320,
        height: 32,
        fontSize: 14,
        defaultText: 'Saturday, June 14 · 4:00 PM',
      ),
      TextLayoutItem(
        label: 'Venue',
        x: 20,
        y: 264,
        width: 320,
        height: 32,
        fontSize: 14,
        defaultText: 'The Grand Hall, City Center',
      ),
    ],
  ),

  // 5. Centered Block ────────────────────────────────────────────────────────
  TextLayoutPreset(
    id: 'centered_block',
    name: 'Centered Block',
    isPro: true,
    description:
        'Vertically centered trio: title, body copy, and a closing footer line.',
    items: [
      TextLayoutItem(
        label: 'Title',
        x: 20,
        y: 170,
        width: 320,
        height: 54,
        fontSize: 28,
        defaultText: 'Celebrate With Us',
      ),
      TextLayoutItem(
        label: 'Body',
        x: 20,
        y: 244,
        width: 320,
        height: 80,
        fontSize: 14,
        defaultText:
            'We are delighted to invite you to share in our joy on this special day.',
      ),
      TextLayoutItem(
        label: 'Footer',
        x: 20,
        y: 344,
        width: 320,
        height: 30,
        fontSize: 13,
        defaultText: 'Kindly RSVP by the 1st of June',
      ),
    ],
  ),

  // 6. Two Lines ─────────────────────────────────────────────────────────────
  TextLayoutPreset(
    id: 'two_lines',
    name: 'Two Lines',
    isPro: true,
    description:
        'Two equal-weight text blocks stacked — great for paired names or a two-part message.',
    items: [
      TextLayoutItem(
        label: 'Line 1',
        x: 20,
        y: 220,
        width: 320,
        height: 48,
        fontSize: 26,
        defaultText: 'First Line',
      ),
      TextLayoutItem(
        label: 'Line 2',
        x: 20,
        y: 284,
        width: 320,
        height: 48,
        fontSize: 26,
        defaultText: 'Second Line',
      ),
    ],
  ),
];
