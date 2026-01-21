import 'package:flutter/material.dart';
import 'package:summify/models/models.dart';

class CardsTypeFilter extends StatelessWidget {
  final KnowledgeCardType? selectedType;
  final Function(KnowledgeCardType?) onTypeSelected;

  const CardsTypeFilter({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  static const Color _selectedColor = Color.fromRGBO(0, 186, 195, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // All types button
            _buildFilterChip(
              label: 'Все',
              isSelected: selectedType == null,
              onTap: () => onTypeSelected(null),
            ),
            const SizedBox(width: 8),

            // Individual type filters
            _buildFilterChip(
              label: 'Тезисы',
              isSelected: selectedType == KnowledgeCardType.thesis,
              onTap: () => onTypeSelected(KnowledgeCardType.thesis),
            ),
            const SizedBox(width: 8),

            _buildFilterChip(
              label: 'Термины',
              isSelected: selectedType == KnowledgeCardType.term,
              onTap: () => onTypeSelected(KnowledgeCardType.term),
            ),
            const SizedBox(width: 8),

            _buildFilterChip(
              label: 'Выводы',
              isSelected: selectedType == KnowledgeCardType.conclusion,
              onTap: () => onTypeSelected(KnowledgeCardType.conclusion),
            ),
            const SizedBox(width: 8),

            _buildFilterChip(
              label: 'Инсайты',
              isSelected: selectedType == KnowledgeCardType.insight,
              onTap: () => onTypeSelected(KnowledgeCardType.insight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey.shade200,
      selectedColor: _selectedColor,
      checkmarkColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}