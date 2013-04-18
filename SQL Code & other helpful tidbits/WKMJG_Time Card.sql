DECLARE @DOCNBR varchar(10)
	,@WKMJG_LOGKEY varchar(10)
	,@ERROR varchar(50)
	,@EMPLOYEE varchar(10)
	,@LABOR_GL_ACCT varchar(15)
	,@GL_SUBACCT varchar(30)
	,@LABOR_CLASS_CD varchar(15)
	,@PJT_ENTITY varchar(32)
	,@PROJECT varchar(16)
	,@REG_HOURS float
	,@TL_DATE smalldatetime
	,@DATEADDED smalldatetime
	,@WORKDATE smalldatetime
	,@APPROVERID varchar(30)
	,@LINENBR int
	   
--	Check WKMJG records for invalid employee id 
UPDATE    xWKMJG_Log_Queue SET Error = 'EM', TransferStatus = 'ERROR'
FROM      xWKMJG_Log_Queue INNER JOIN xWKMJG_Time_Det ON xWKMJG_Log_Queue.LogKey = xWKMJG_Time_Det.LogKey
WHERE     (xWKMJG_Log_Queue.TransferStatus = 'In Process') AND (xWKMJG_Time_Det.UserID NOT IN
          (SELECT employee FROM PJEMPLOY))
          
          	   
--	Check WKMJG records for invalid approver id 
UPDATE    xWKMJG_Log_Queue SET Error = 'AP', TransferStatus = 'ERROR'
FROM      xWKMJG_Log_Queue INNER JOIN xWKMJG_Time_Det ON xWKMJG_Log_Queue.LogKey = xWKMJG_Time_Det.LogKey
WHERE     (xWKMJG_Log_Queue.TransferStatus = 'In Process') AND (xWKMJG_Time_Det.ApproverID NOT IN
          (SELECT employee FROM PJEMPLOY))

--	Check WKMJG records for invalid Project Code 
UPDATE    xWKMJG_Log_Queue SET Error = 'PR', TransferStatus = 'ERROR'
FROM      xWKMJG_Log_Queue INNER JOIN xWKMJG_Time_Det ON xWKMJG_Log_Queue.LogKey = xWKMJG_Time_Det.LogKey
WHERE     (xWKMJG_Log_Queue.TransferStatus = 'In Process') AND (xWKMJG_Time_Det.ProjectNumber NOT IN
          (SELECT project FROM PJPROJ))

--	Check WKMJG records for invalid Labor GL acct 
UPDATE    xWKMJG_Log_Queue SET Error = 'LB', TransferStatus = 'ERROR'
FROM      xWKMJG_Log_Queue INNER JOIN xWKMJG_Time_Det ON xWKMJG_Log_Queue.LogKey = xWKMJG_Time_Det.LogKey
WHERE     (xWKMJG_Log_Queue.TransferStatus = 'In Process') AND (xWKMJG_Time_Det.ProjectNumber NOT IN
          (SELECT project FROM PJPROJ WHERE RTRIM(labor_gl_acct) > ''))

--	Check WKMJG records for invalid Employee Labor class  
UPDATE    xWKMJG_Log_Queue SET Error = 'EP', TransferStatus = 'ERROR'
FROM      xWKMJG_Log_Queue INNER JOIN xWKMJG_Time_Det ON xWKMJG_Log_Queue.LogKey = xWKMJG_Time_Det.LogKey
WHERE     (xWKMJG_Log_Queue.TransferStatus = 'In Process') AND (xWKMJG_Time_Det.UserID NOT IN
          (SELECT employee FROM xPJEMPPJT WHERE effect_date <= GETDATE()))

--	Check WKMJG records for invalid Project Task or Function Code
UPDATE    xWKMJG_Log_Queue SET Error = 'PT', TransferStatus = 'ERROR'
FROM      xWKMJG_Log_Queue INNER JOIN xWKMJG_Time_Det ON xWKMJG_Log_Queue.LogKey = xWKMJG_Time_Det.LogKey
WHERE     (xWKMJG_Log_Queue.TransferStatus = 'In Process') AND (RTRIM(xWKMJG_Time_Det.ProjectNumber) + '-' 
		+ RTRIM(xWKMJG_Time_Det.SalesAccountNumber) NOT IN
          (SELECT RTRIM(project) + '-' + RTRIM(pjt_entity) FROM PJPENT))

--	Check WKMJG records for invalid Timecard Date
UPDATE    xWKMJG_Log_Queue SET Error = 'DT', TransferStatus = 'ERROR'
FROM      xWKMJG_Log_Queue INNER JOIN xWKMJG_Time_Det ON xWKMJG_Log_Queue.LogKey = xWKMJG_Time_Det.LogKey
WHERE     (xWKMJG_Log_Queue.TransferStatus = 'In Process') AND (ISDATE(xWKMJG_Time_Det.TransactionDate) <> 1)

--	Check WKMJG records for invalid Work Date Date
UPDATE    xWKMJG_Log_Queue SET Error = 'WK', TransferStatus = 'ERROR'
FROM      xWKMJG_Log_Queue INNER JOIN xWKMJG_Time_Det ON xWKMJG_Log_Queue.LogKey = xWKMJG_Time_Det.LogKey
WHERE     (xWKMJG_Log_Queue.TransferStatus = 'In Process') AND (ISDATE(xWKMJG_Time_Det.WorkDate) <> 1)

--	Check WKMJG records for invalid Timecard Hours
UPDATE    xWKMJG_Log_Queue SET Error = 'HR', TransferStatus = 'ERROR'
FROM      xWKMJG_Log_Queue INNER JOIN xWKMJG_Time_Det ON xWKMJG_Log_Queue.LogKey = xWKMJG_Time_Det.LogKey
WHERE     (xWKMJG_Log_Queue.TransferStatus = 'In Process') AND (ISNUMERIC(xWKMJG_Time_Det.TotalHours) <> 1)   


DECLARE CSR_HEADER CURSOR FOR
	SELECT a.LogKey, a.DateAdded, b.ApproverID FROM xWKMJG_Log_Queue a
	 INNER JOIN xWKMJG_Time_Det b ON a.LogKey = b.LogKey
		WHERE a.TransferStatus = 'In Process' GROUP BY a.LogKey, a.DateAdded, b.ApproverID

OPEN CSR_HEADER
FETCH NEXT FROM CSR_HEADER INTO 
	@WKMJG_LOGKEY, @DATEADDED, @APPROVERID

WHILE @@FETCH_STATUS = 0
	BEGIN
	--Get Next Doc Nbr from DSL	
	BEGIN TRANSACTION
	SELECT	@DOCNBR = LastUsed_labhdr FROM	PJDOCNUM WHERE id = 13
	SET @DOCNBR = RIGHT('0000000000' + CAST((CAST(@DOCNBR as int) + 1) as varchar(10)), 10)
	UPDATE PJDOCNUM	SET LastUsed_labhdr = @DOCNBR WHERE id = 13
    COMMIT TRANSACTION
    
	SET @LINENBR = -32768
	
	INSERT INTO [PJTIMHDR]
	   ([approver]
	   ,[BaseCuryId]
	   ,[cpnyId]
	   ,[crew_cd]
	   ,[crtd_datetime]
	   ,[crtd_prog]
	   ,[crtd_user]
	   ,[CuryEffDate]
	   ,[CuryId]
	   ,[CuryMultDiv]
	   ,[CuryRate]
	   ,[CuryRateType]
	   ,[docnbr]
	   ,[end_time]
	   ,[lupd_datetime]
	   ,[lupd_prog]
	   ,[lupd_user]
	   ,[multi_emp_sw]
	   ,[noteid]
	   ,[percent_comp]
	   ,[preparer_id]
	   ,[project]
	   ,[pjt_entity]
	   ,[shift]
	   ,[start_time]
	   ,[th_comment]
	   ,[th_date]
	   ,[th_key]
	   ,[th_id01]
	   ,[th_id02]
	   ,[th_id03]
	   ,[th_id04]
	   ,[th_id05]
	   ,[th_id06]
	   ,[th_id07]
	   ,[th_id08]
	   ,[th_id09]
	   ,[th_id10]
	   ,[th_id11]
	   ,[th_id12]
	   ,[th_id13]
	   ,[th_id14]
	   ,[th_id15]
	   ,[th_id16]
	   ,[th_id17]
	   ,[th_id18]
	   ,[th_id19]
	   ,[th_id20]
	   ,[th_status]
	   ,[th_type]
	   ,[user1]
	   ,[user2]
	   ,[user3]
	   ,[user4])
	VALUES(
	   ' ' --[approver]
	   ,'USD' --[BaseCuryId]
	   ,'DENVER' --[cpnyId]
	   ,'' --[crew_cd]
	   ,CAST(GETDATE() as smalldatetime)--[crtd_datetime]
	   ,'IMPORT' --[crtd_prog]
	   ,'IMPORT' --[crtd_user]
	   ,' ' --[CuryEffDate]
	   ,'USD' --[CuryId]
	   ,'M' --[CuryMultDiv]
	   ,1 --[CuryRate] 
	   ,'' --[CuryRateType]
	   ,@DOCNBR --[docnbr]
	   ,'' --[end_time]
	   ,CAST(GETDATE() as smalldatetime) --[lupd_datetime]
	   ,'IMPORT' --[lupd_prog]
	   ,'IMPORT' --[lupd_user]
	   ,'' --[multi_emp_sw]
	   ,0 --[noteid]
	   ,0 --[percent_comp]
	   ,@APPROVERID --[preparer_id]    
	   ,' ' --[project]        
	   ,'' --[pjt_entity]
	   ,'' --[shift]
	   ,'' --[start_time]
	   ,'WKMJG TIME ENTRY ' + CAST(CAST(@DATEADDED as Date) AS varchar(10)) --[th_comment]
	   ,@DATEADDED --[th_date]
	   ,'' --[th_key]
	   ,'' --[th_id01]
	   ,'' --[th_id02]
	   ,'' --[th_id03]
	   ,'' --[th_id04]
	   ,'' --[th_id05]
	   ,'' --[th_id06]
	   ,'' --[th_id07]
	   ,0 --[th_id08]
	   ,' ' --[th_id09]
	   ,0 --[th_id10]
	   ,'' --[th_id11]
	   ,'' --[th_id121]
	   ,'' --[th_id13]
	   ,'' --[th_id14]
	   ,'' --[th_id15]
	   ,'' --[th_id16]
	   ,'' --[th_id17]
	   ,0 --[th_id18]
	   ,'1/1/1900' --[th_id19]
	   ,0 --[th_id20]
	   ,'C' --[th_status]
	   ,'' --[th_type]
	   ,@WKMJG_LOGKEY --[user1]
	   ,'' --[user2]
	   ,0 --[user3]
	   ,0 --[user4]
	)
	DECLARE CSR_DETAIL CURSOR FOR
		SELECT xWKMJG_Time_Det.UserID
		, PJPROJ.labor_gl_acct
		, PJEmploy.gl_subacct
		, xPJEMPPJT.labor_class_cd
		, xWKMJG_Time_Det.ProjectNumber
		, xWKMJG_Time_Det.TotalHours
		, xWKMJG_Time_Det.TransactionDate
		, xWKMJG_Time_Det.SalesAccountNumber
		, xWKMJG_Time_Det.WorkDate
		FROM xWKMJG_Time_Det INNER JOIN PJEMPLOY ON xWKMJG_Time_Det.UserID = PJEMPLOY.employee
			LEFT JOIN xPJEMPPJT ON xWKMJG_Time_Det.UserID = xPJEMPPJT.employee 
			INNER JOIN PJPROJ ON xWKMJG_Time_Det.ProjectNumber = PJPROJ.Project
		WHERE
			xWKMJG_Time_Det.LogKey = @WKMJG_LOGKEY

		OPEN CSR_DETAIL 
		FETCH NEXT FROM CSR_DETAIL INTO
			@EMPLOYEE
		   ,@LABOR_GL_ACCT
		   ,@GL_SUBACCT
		   ,@LABOR_CLASS_CD
		   ,@PROJECT
		   ,@REG_HOURS
		   ,@TL_DATE
		   ,@PJT_ENTITY
		   ,@WORKDATE
		   
		
		WHILE @@FETCH_STATUS = 0
			BEGIN
			INSERT INTO [PJTIMDET]
			   ([cert_pay_sw]
			   ,[CpnyId_chrg]
			   ,[CpnyId_eq_home]
			   ,[CpnyId_home]
			   ,[crtd_datetime]
			   ,[crtd_prog]
			   ,[crtd_user]
			   ,[docnbr]
			   ,[earn_type_id]
			   ,[employee]
			   ,[elapsed_time]
			   ,[end_time]
			   ,[equip_amt]
			   ,[equip_home_subacct]
			   ,[equip_id]
			   ,[equip_rate]
			   ,[equip_rate_cd]
			   ,[equip_rate_indicator]
			   ,[equip_units]
			   ,[equip_uom]
			   ,[gl_acct]
			   ,[gl_subacct]
			   ,[group_code]
			   ,[labor_amt]
			   ,[labor_class_cd]
			   ,[labor_rate]
			   ,[labor_rate_indicator]
			   ,[linenbr]
			   ,[lupd_datetime]
			   ,[lupd_prog]
			   ,[lupd_user]
			   ,[noteid]
			   ,[ot1_hours]
			   ,[ot2_hours]
			   ,[pjt_entity]
			   ,[project]
			   ,[reg_hours]
			   ,[shift]
			   ,[start_time]
			   ,[tl_date]
			   ,[tl_id01]
			   ,[tl_id02]
			   ,[tl_id03]
			   ,[tl_id04]
			   ,[tl_id05]
			   ,[tl_id06]
			   ,[tl_id07]
			   ,[tl_id08]
			   ,[tl_id09]
			   ,[tl_id10]
			   ,[tl_id11]
			   ,[tl_id12]
			   ,[tl_id13]
			   ,[tl_id14]
			   ,[tl_id15]
			   ,[tl_id16]
			   ,[tl_id17]
			   ,[tl_id18]
			   ,[tl_id19]
			   ,[tl_id20]
			   ,[tl_status]
			   ,[union_cd]
			   ,[user1]
			   ,[user2]
			   ,[user3]
			   ,[user4]
			   ,[work_comp_cd]
			   ,[work_type])
	VALUES
			   ('N' --[cert_pay_sw]
			   ,'DENVER' --[CpnyId_chrg]
			   ,'' --[CpnyId_eq_home]
			   ,'DENVER' --[CpnyId_home]
			   ,CAST(GETDATE() AS smalldatetime) --[crtd_datetime]
			   ,'IMPORT' --[crtd_prog]
			   ,'IMPORT' --[crtd_user]
			   ,@DOCNBR --[docnbr]
			   ,'' --[earn_type_id]
			   ,@EMPLOYEE --[employee]
			   ,'' --[elapsed_time]
			   ,'' --[end_time]
			   ,0 --[equip_amt]
			   ,'' --[equip_home_subacct]
			   ,'' --[equip_id]
			   ,0 --[equip_rate]
			   ,'RATE1' --[equip_rate_cd]
			   ,'' --[equip_rate_indicator]
			   ,0 --[equip_units]
			   ,'' --[equip_uom]
			   ,@LABOR_GL_ACCT --[gl_acct]
			   ,@GL_SUBACCT --[gl_subacct]
			   ,'' --[group_code]
			   ,0 --[labor_amt]
			   ,@LABOR_CLASS_CD --[labor_class_cd]
			   ,0 --[labor_rate]
			   ,'' --[labor_rate_indicator]
			   ,@LINENBR --[linenbr]	
			   ,CAST(GETDATE() AS smalldatetime) --[lupd_datetime]
			   ,'IMPORT' --[lupd_prog]
			   ,'IMPORT' --[lupd_user]
			   ,0 --[noteid]
			   ,0 --[ot1_hours]
			   ,0 --[ot2_hours]
			   ,@PJT_ENTITY --[pjt_entity]
			   ,@PROJECT --[project]
			   ,@REG_HOURS --[reg_hours]
			   ,'' --[shift]
			   ,'' --[start_time]
			   ,@WORKDATE --[tl_date]
			   ,'' --[tl_id01]
			   ,'' --[tl_id02]
			   ,'' --[tl_id03]
			   ,'' --[tl_id04]
			   ,'' --[tl_id05]
			   ,'' --[tl_id06]
			   ,'' --[tl_id07]
			   ,0 --[tl_id08]
			   ,' ' --[tl_id09]
			   ,0 --[tl_id10]
			   ,@GL_SUBACCT  --[tl_id11]
			   ,'' --[tl_id12]
			   ,'' --[tl_id13]
			   ,'' --[tl_id14]
			   ,'' --[tl_id15]
			   ,'' --[tl_id16]
			   ,'' --[tl_id17]
			   ,0 --[tl_id18]
			   ,'1/1/1900' --[tl_id19]
			   ,0 --[tl_id20]
			   ,'' --[tl_status]
			   ,'' --[union_cd]
			   ,''--[user1]
			   ,@WKMJG_LOGKEY  --[user2]
			   ,0 --[user3]
			   ,0 --[user4]
			   ,'' --[work_comp_cd]
			   ,'') --[work_type]

	SET @LINENBR = @LINENBR + 10

			FETCH NEXT FROM CSR_DETAIL INTO
			@EMPLOYEE
		   ,@LABOR_GL_ACCT
		   ,@GL_SUBACCT
		   ,@LABOR_CLASS_CD
		   ,@PROJECT
		   ,@REG_HOURS
		   ,@TL_DATE
		   ,@PJT_ENTITY
		   ,@WORKDATE

		END

	CLOSE CSR_DETAIL
	DEALLOCATE CSR_DETAIL

	UPDATE xWKMJG_Log_Queue
	SET Error = 'NONE', TransferStatus = 'Transfered - ' + @DOCNBR, DateTransferred = CAST(GETDATE() as smalldatetime)
	WHERE xWKMJG_Log_Queue.LogKey = @WKMJG_LOGKEY
	
FETCH NEXT FROM CSR_HEADER INTO 
	@WKMJG_LOGKEY, @DATEADDED, @APPROVERID

END

CLOSE CSR_HEADER
DEALLOCATE CSR_HEADER





