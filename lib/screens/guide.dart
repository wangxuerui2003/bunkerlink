import 'package:bunkerlink/widgets/CustomBottomNavigationBar.dart';
import 'package:flutter/material.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Survival Guide'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Understanding the Predator',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildSubSection(
              'Species Overview',
              'Predators, also known as Kaiji, are a highly advanced alien species known for their hunting prowess and advanced technology. They hunt for sport and honor.',
            ),
            _buildSubSection(
              'Physiology',
              'Predators are larger and stronger than humans, with heightened senses and advanced combat skills. They have a unique mandible structure and dreadlock-like appendages.',
            ),
            _buildSubSection(
              'Technology',
              'Predators use advanced weaponry and equipment:',
              children: [
                _buildBullet('Cloaking Device', 'Makes them nearly invisible.'),
                _buildBullet('Plasma Caster', 'Shoulder-mounted energy weapon.'),
                _buildBullet('Wrist Blades', 'Retractable blades on their arms.'),
                _buildBullet('Biomask', 'Enhances vision modes and provides a targeting system.'),
                _buildBullet('Self-Destruct Device', 'Used as a last resort to avoid capture.'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Preparation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSubSection(
              'Gather Supplies',
              'Ensure you have access to basic survival gear such as food, water, medical supplies, and communication devices.',
            ),
            _buildSubSection(
              'Study the Terrain',
              'Familiarize yourself with the environment. Predators prefer dense jungles and urban areas for hunting.',
            ),
            _buildSubSection(
              'Create Safe Zones',
              'Establish secure locations where you can hide and fortify against Predator attacks.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Tactics for Evading and Defending',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildSubSection(
              'Thermal Camouflage',
              'Use mud or other materials to mask your heat signature. Predators rely heavily on thermal vision.',
            ),
            _buildSubSection(
              'Noise Discipline',
              'Minimize sound to avoid detection. Predators have acute hearing.',
            ),
            _buildSubSection(
              'Stay Out of Sight',
              'Avoid open areas. Use the environment to break line of sight.',
            ),
            _buildSubSection(
              'Weaponry',
              'Standard firearms are less effective. Focus on traps, explosives, and melee weapons for close combat.',
            ),
            _buildSubSection(
              'Distraction',
              'Use noise makers or other distractions to lure the Predator away or confuse it.',
            ),
            SizedBox(height: 20),
            Text(
              'Combat Strategies',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildSubSection(
              'Team Coordination',
              'Work in groups to increase your chances of survival. Use coordinated attacks and communication.',
            ),
            _buildSubSection(
              'Target Weak Points',
              'Aim for the head or unarmored parts of the body. Predators are resilient but not invincible.',
            ),
            _buildSubSection(
              'Utilize Traps',
              'Set up traps to immobilize or injure the Predator. Use the environment to your advantage.',
            ),
            _buildSubSection(
              'Stealth and Ambush',
              'Engage in guerrilla tactics. Hit and run, use ambushes, and avoid prolonged engagements.',
            ),
            SizedBox(height: 20),
            Text(
              'Psychological Warfare',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildSubSection(
              'Intimidation',
              'Predators respect strength and cunning. Use displays of power or trickery to create hesitation.',
            ),
            _buildSubSection(
              'Understand Their Code',
              'Predators follow a code of honor. Unarmed or severely injured individuals are often spared. Exploit this code when possible.',
            ),
            SizedBox(height: 20),
            Text(
              'Post-Encounter Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildSubSection(
              'Escape and Evade',
              'Once the Predator is injured or distracted, use the opportunity to escape the area.',
            ),
            _buildSubSection(
              'Medical Attention',
              'Treat injuries immediately. Predator weapons can cause severe trauma.',
            ),
            _buildSubSection(
              'Report and Relocate',
              'Inform authorities or other survivors of Predator activity. Relocate to a safer area to avoid further encounters.',
            ),
            SizedBox(height: 20),
            Text(
              'Long-Term Survival',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildSubSection(
              'Knowledge Sharing',
              'Share information about Predator weaknesses and tactics with others.',
            ),
            _buildSubSection(
              'Community Defense',
              'Organize with other survivors to create a defense network.',
            ),
            _buildSubSection(
              'Continuous Vigilance',
              'Stay alert and continuously adapt your strategies. Predators are relentless hunters.',
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {},
      ),    
    );
  }

  Widget _buildSubSection(String title, String content, {List<Widget>? children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          content,
          style: TextStyle(fontSize: 14),
        ),
        if (children != null) ...children.map((child) => Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: child,
        )).toList(),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBullet(String title, String description) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Icon(Icons.circle, size: 10),
      title: Text(title),
      subtitle: Text(description),
    );
  }
}
