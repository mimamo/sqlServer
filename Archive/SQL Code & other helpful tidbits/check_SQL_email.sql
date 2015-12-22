-- Workamajig Time Exception Report
	/*-- Error constants
	declare @kErrDuplicateProjectNumber	int		select @kErrDuplicateProjectNumber = -1
	declare @kErrInvalidClient	int				select @kErrInvalidClient = -2
	declare @kErrTemplateProject int			select @kErrTemplateProject = -3
	declare @kErrCreatingProject int			select @kErrCreatingProject = -4
	declare @kErrInvalidProjectType int			select @kErrInvalidProjectType = -5
	*/
	
SELECT a.[job_number]
      ,a.[job_title]
      ,a.[parent_job]
      ,a.[sub_prod_code]
      ,RTRIM(c.[code_group]) AS sub_prod_group
      ,RTRIM(b.[pm_id01]) AS client_id
      ,RTRIM(b.[pm_id05]) AS sub_type  -- DAB - Added 4/25/2012 - this will get the sub-type field for the project
      , a.date_created
      , a.trigger_status as 'transfer_status'
      , case when a.trigger_status = '-1' Then 'Error: Duplicate Project Number' 
			when a.trigger_status = '-2' Then 'Error: Invalid Client' 
			when a.trigger_status = '-3' Then 'Error: Template Project' 
			when a.trigger_status = '-4' Then 'Error: Creating Project' 
			when a.trigger_status = '-5' Then 'Error: Invalid Project Type' 
		end as 'status_desc'
  FROM [xTRAPS_JOBHDR] a
  INNER JOIN [PJPROJ] b
  ON a.job_number = b.project
  INNER JOIN [xIGProdCode] c
  ON a.sub_prod_code = c.code_ID
  WHERE a.trigger_status <> 'IM'
  order by a.date_created desc