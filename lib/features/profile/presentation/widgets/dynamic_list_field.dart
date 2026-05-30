import 'package:flutter/material.dart';

// A reusable widget for any "add items to a list" UI.
// Used for: skills, education entries, experience entries, projects.
//
// Generic type T means it works for any data type —
// String for skills, Map for education/experience/projects.
//
// The parent passes:
// - items: the current list
// - onAdd: called when user adds an item
// - onRemove: called when user removes an item
// - itemBuilder: how to render each item
// - addBuilder: the "add new item" UI (could be a simple text field or a form)
class DynamicListField<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(T item, int index, VoidCallback onRemove) itemBuilder;
  final Widget addWidget;

  const DynamicListField({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.addWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 10),

        // Existing items
        ...items.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: itemBuilder(
              entry.value,
              entry.key,
              () {}, // removal handled inside itemBuilder via callback
            ),
          );
        }),

        // Add new item UI
        addWidget,
      ],
    );
  }
}

// Skills chip input — type a skill, press enter or + to add
class SkillsInput extends StatefulWidget {
  final List<String> skills;
  final void Function(String) onAdd;
  final void Function(String) onRemove;

  const SkillsInput({
    super.key,
    required this.skills,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<SkillsInput> createState() => _SkillsInputState();
}

class _SkillsInputState extends State<SkillsInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final skill = _controller.text.trim().toLowerCase();
    if (skill.isNotEmpty && !widget.skills.contains(skill)) {
      widget.onAdd(skill);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Existing skill chips
        if (widget.skills.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.skills.map((skill) {
              return Chip(
                label: Text(skill, style: const TextStyle(fontSize: 13)),
                onDeleted: () => widget.onRemove(skill),
                deleteIconColor: Colors.grey.shade500,
                backgroundColor: const Color(0xFF4F46E5).withOpacity(0.08),
                side: BorderSide.none,
                labelStyle: const TextStyle(color: Color(0xFF4F46E5)),
              );
            }).toList(),
          ),

        const SizedBox(height: 10),

        // Add skill input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Add a skill (e.g. Flutter)',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF4F46E5),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _add(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _add,
              icon: const Icon(Icons.add_circle_outline),
              color: const Color(0xFF4F46E5),
            ),
          ],
        ),
      ],
    );
  }
}

// Generic entry card — used for education, experience, projects
// Shows a summary line + remove button
class EntryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onRemove;

  const EntryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: Colors.grey.shade500),
            onPressed: onRemove,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
