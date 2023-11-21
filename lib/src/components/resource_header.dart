import 'package:flutter/material.dart';


class ResourceHeader extends StatelessWidget {
  const ResourceHeader(
    this.resource, {
    super.key,
    this.onTap,
  });

  final String resource;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(child: Text(resource)),
    );
  }
}
