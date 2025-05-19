import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inventra/constants/app_titles.dart';
import 'package:inventra/widgets/app_text.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Monthly';
  final List<String> _periods = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const AppText(title: AppTitle.reportHeader),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              _showExportDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Invoices'),
            Tab(text: 'Clients'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildInvoicesTab(),
          _buildClientsTab(),
        ],
      ),
    );
  }


  // Overview tab widget
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateRangeSelector(),
          const SizedBox(height: 24),
          _buildFinancialSummary(),
          const SizedBox(height: 24),
          _buildRevenueChart(),
          const SizedBox(height: 24),
          _buildInvoiceStatusCards(),
          const SizedBox(height: 24),
          _buildTopClients(),
        ],
      ),
    );
  }


  // date range widget
  Widget _buildDateRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),


          // 
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != _startDate) {
                      setState(() {
                        _startDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM d, yyyy').format(_startDate),
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade700),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // to
              const Text('to'),
              const SizedBox(width: 16),


              // end date range
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != _endDate) {
                      setState(() {
                        _endDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM d, yyyy').format(_endDate),
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade700),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _periods.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_periods[index]),
                    selected: _selectedPeriod == _periods[index],
                    onSelected: (selected) {
                      setState(() {
                        _selectedPeriod = _periods[index];
                        // Update date range based on period
                        if (_periods[index] == 'Daily') {
                          _startDate = DateTime.now();
                          _endDate = DateTime.now();
                        } else if (_periods[index] == 'Weekly') {
                          _startDate = DateTime.now().subtract(const Duration(days: 7));
                          _endDate = DateTime.now();
                        } else if (_periods[index] == 'Monthly') {
                          _startDate = DateTime.now().subtract(const Duration(days: 30));
                          _endDate = DateTime.now();
                        } else if (_periods[index] == 'Yearly') {
                          _startDate = DateTime.now().subtract(const Duration(days: 365));
                          _endDate = DateTime.now();
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Revenue',
            '\$28,459.65',
            Icons.trending_up,
            Colors.green,
            '12.5% vs last period',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Outstanding',
            '\$4,320.00',
            Icons.warning_amber_rounded,
            Colors.orange,
            '3 overdue invoices',
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color iconColor, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: Colors.grey.shade600)),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue Trend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Color(0xff68737d),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('JAN', style: style);
                            break;
                          case 2:
                            text = const Text('MAR', style: style);
                            break;
                          case 4:
                            text = const Text('MAY', style: style);
                            break;
                          case 6:
                            text = const Text('JUL', style: style);
                            break;
                          case 8:
                            text = const Text('SEP', style: style);
                            break;
                          case 10:
                            text = const Text('NOV', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(
                          meta: meta,
                          // axisSide: meta.axisSide,
                          child: text,
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Color(0xff67727d),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        String text;
                        switch (value.toInt()) {
                          case 1:
                            text = '10k';
                            break;
                          case 3:
                            text = '30k';
                            break;
                          case 5:
                            text = '50k';
                            break;
                          default:
                            return Container();
                        }
                        return Text(text, style: style, textAlign: TextAlign.left);
                      },
                      reservedSize: 32,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d), width: 1),
                ),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 2),
                      FlSpot(2, 5),
                      FlSpot(3, 3.1),
                      FlSpot(4, 4),
                      FlSpot(5, 3),
                      FlSpot(6, 4),
                      FlSpot(7, 4.5),
                      FlSpot(8, 5),
                      FlSpot(9, 3.9),
                      FlSpot(10, 4.2),
                      FlSpot(11, 5.5),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        ColorTween(begin: Theme.of(context).primaryColor, end: Colors.blue)
                            .lerp(0.2)!,
                        ColorTween(begin: Theme.of(context).primaryColor, end: Colors.blue)
                            .lerp(0.2)!,
                      ],
                    ),
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          ColorTween(begin: Theme.of(context).primaryColor, end: Colors.blue)
                              .lerp(0.2)!
                              .withOpacity(0.1),
                          ColorTween(begin: Theme.of(context).primaryColor, end: Colors.blue)
                              .lerp(0.2)!
                              .withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceStatusCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Invoice Status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatusCard('Paid', '45', Colors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatusCard('Pending', '12', Colors.orange),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatusCard('Overdue', '3', Colors.red),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusCard(String status, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                status,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopClients() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Clients',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  _tabController.animateTo(2); // Switch to Clients tab
                },
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildClientItem('Acme Corporation', '\$8,450.00', '12 invoices'),
          const Divider(),
          _buildClientItem('Globex Inc.', '\$6,320.40', '8 invoices'),
          const Divider(),
          _buildClientItem('Stark Industries', '\$4,890.25', '5 invoices'),
        ],
      ),
    );
  }

  Widget _buildClientItem(String name, String total, String invoiceCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Text(
              name.substring(0, 1),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  invoiceCount,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            total,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoicesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSearchAndFilterBar(),
        const SizedBox(height: 16),
        _buildInvoiceList(),
      ],
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search invoices...',
                isDense: true,
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey.shade600),
              ),
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.sort, color: Colors.grey.shade600),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'date',
                child: Text('Sort by Date'),
              ),
              const PopupMenuItem(
                value: 'amount',
                child: Text('Sort by Amount'),
              ),
              const PopupMenuItem(
                value: 'status',
                child: Text('Sort by Status'),
              ),
            ],
            onSelected: (value) {
              // Handle sorting
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceList() {
    return Column(
      children: [
        _buildInvoiceItem(
          'INV-001',
          'Acme Corporation',
          '\$2,450.00',
          'Paid',
          Colors.green,
          DateTime.now().subtract(const Duration(days: 15)),
        ),
        _buildInvoiceItem(
          'INV-002',
          'Globex Inc.',
          '\$1,890.00',
          'Pending',
          Colors.orange,
          DateTime.now().subtract(const Duration(days: 10)),
        ),
        _buildInvoiceItem(
          'INV-003',
          'Stark Industries',
          '\$3,450.00',
          'Paid',
          Colors.green,
          DateTime.now().subtract(const Duration(days: 8)),
        ),
        _buildInvoiceItem(
          'INV-004',
          'Wayne Enterprises',
          '\$5,680.00',
          'Overdue',
          Colors.red,
          DateTime.now().subtract(const Duration(days: 45)),
        ),
        _buildInvoiceItem(
          'INV-005',
          'LexCorp',
          '\$1,230.00',
          'Paid',
          Colors.green,
          DateTime.now().subtract(const Duration(days: 5)),
        ),
        _buildInvoiceItem(
          'INV-006',
          'Umbrella Corp',
          '\$2,870.00',
          'Pending',
          Colors.orange,
          DateTime.now().subtract(const Duration(days: 2)),
        ),
        _buildInvoiceItem(
          'INV-007',
          'Cyberdyne Systems',
          '\$1,500.00',
          'Overdue',
          Colors.red,
          DateTime.now().subtract(const Duration(days: 30)),
        ),
      ],
    );
  }

  Widget _buildInvoiceItem(
    String invoiceId,
    String client,
    String amount,
    String status,
    Color statusColor,
    DateTime date,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Text(
              invoiceId,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(client),
            const SizedBox(height: 4),
            Text(
              'Issued: ${DateFormat('MMM d, yyyy').format(date)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: Text(
          amount,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: () {
          // Navigate to invoice details
        },
      ),
    );
  }

  Widget _buildClientsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSearchAndFilterBar(),
        const SizedBox(height: 16),
        _buildClientsList(),
      ],
    );
  }

  Widget _buildClientsList() {
    return Column(
      children: [
        _buildClientListItem(
          'Acme Corporation',
          'acme@example.com',
          '\$8,450.00',
          12,
        ),
        _buildClientListItem(
          'Globex Inc.',
          'info@globex.com',
          '\$6,320.40',
          8,
        ),
        _buildClientListItem(
          'Stark Industries',
          'accounts@stark.com',
          '\$4,890.25',
          5,
        ),
        _buildClientListItem(
          'Wayne Enterprises',
          'finance@wayne.com',
          '\$5,680.00',
          7,
        ),
        _buildClientListItem(
          'LexCorp',
          'billing@lexcorp.com',
          '\$3,230.75',
          4,
        ),
        _buildClientListItem(
          'Umbrella Corp',
          'payments@umbrella.com',
          '\$2,870.00',
          3,
        ),
      ],
    );
  }

  Widget _buildClientListItem(String name, String email, String totalBilled, int invoiceCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          radius: 24,
          child: Text(
            name.substring(0, 1),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(email),
            const SizedBox(height: 4),
            Text(
              '$invoiceCount invoices | Total: $totalBilled',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            // Navigate to client details
          },
        ),
        onTap: () {
          // Navigate to client details
        },
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('PDF'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle PDF export
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_chart),
                title: const Text('Excel'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle Excel export
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('CSV'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle CSV export
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Reports'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Status'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: true,
                    onSelected: (selected) {},
                  ),
                  FilterChip(
                    label: const Text('Paid'),
                    selected: false,
                    onSelected: (selected) {},
                  ),
                  FilterChip(
                    label: const Text('Pending'),
                    selected: false,
                    onSelected: (selected) {},
                  ),
                  FilterChip(
                    label: const Text('Overdue'),
                    selected: false,
                    onSelected: (selected) {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Amount Range'),
              const SizedBox(height: 8),
              RangeSlider(
                values: const RangeValues(0, 10000),
                min: 0,
                max: 10000,
                divisions: 20,
                labels: const RangeLabels('\$0', '\$10,000'),
                onChanged: (RangeValues values) {},
              ),
              const SizedBox(height: 16),
              const Text('Client'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                value: 'All Clients',
                items: ['All Clients', 'Acme Corporation', 'Globex Inc.', 'Stark Industries']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            ],
          ),
        );
      });
  }
}