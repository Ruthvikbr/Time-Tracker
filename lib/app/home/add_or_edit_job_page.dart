import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/components/showAlertDialog.dart';
import 'package:time_tracker/app/components/showExceptionAlertDialog.dart';
import 'package:time_tracker/app/model/job.dart';
import 'package:time_tracker/services/database.dart';

class AddOrEditJobPage extends StatefulWidget {
  const AddOrEditJobPage({
    Key? key,
    required this.database,
    this.job,
  }) : super(key: key);
  final Database database;
  final Job? job;

  static Future<void> navigate(
      {required BuildContext context,required Database database, Job? job}) async {
    await Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(
      builder: (context) => AddOrEditJobPage(
        database: database,
        job: job,
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  _AddOrEditJobPageState createState() => _AddOrEditJobPageState();
}

class _AddOrEditJobPageState extends State<AddOrEditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  int _ratePerHour = 0;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job != null ? "Edit job" : "Add job"),
        elevation: 4.0,
        actions: <Widget>[
          TextButton(
            child: Text(
              "Save",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: _submit,
          )
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ));
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name,
        decoration: InputDecoration(labelText: "Job name"),
        onSaved: (value) => _name = value != null ? value : "",
        validator: (value) =>
            value != null && value.isNotEmpty ? null : "Name can't be empty",
      ),
      TextFormField(
        initialValue: _ratePerHour != 0 ? "$_ratePerHour" : null,
        decoration: InputDecoration(labelText: "Rate per hour"),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) =>
            _ratePerHour = value != null ? int.tryParse(value) ?? 0 : 0,
        validator: (value) =>
            value != null && value.isNotEmpty ? null : "Rate can't be empty",
      ),
    ];
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobStreams().first;
        final allNames = jobs.map((job) => job.name).toList();
        if(widget.job!=null){
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: "Job already exists",
            content: "The job you're trying to add already exists",
            defaultActionText: "Ok",
          );
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentString();
          final job = Job(
              id: id,
              name: _name,
              ratePerHour: _ratePerHour);
          await widget.database.createOrUpdateJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: "Add failed",
          exception: e,
        );
      }
    }
  }
}
