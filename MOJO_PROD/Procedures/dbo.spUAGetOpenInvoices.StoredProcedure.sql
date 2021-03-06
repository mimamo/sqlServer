USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spUAGetOpenInvoices]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUAGetOpenInvoices]
	
AS

	SET NOCOUNT ON

/*
|| When     Who Rel     What
|| 10/23/08 GHL 10.011  Creation for University of Alberta 
|| 11/06/08 GHL 10.012  Joining with tUser table using tInvoice.PrimaryContactKey vs BillingContactKey
|| 11/17/08 GHL 10.013  (Issue 40519) Request by Seb Brault, Steve Kress to add Project Name 
|| 03/24/09 GHL 10.022  (Issue 49789) Changed Amount-SPLIT-MTHD to Amount_SPLIT_MTHD at Steve's request
*/

	declare @CompanyKey int
	select @CompanyKey = 1
	
	create table #invoice (InvoiceKey int null
		,ClassKey int null
		,InvoiceNumber varchar(35) null
		,InvoiceTotalAmount money null
		,PostingDate datetime null
		,BillingContactKey int null)
	
	create table #line (
		InvoiceKey int null		
		,InvoiceLineKey int null
		,ProjectKey int null
		,SalesAccountKey int null
		,LineClassKey int null
		,LineTotalAmount money null
		,DetailTotalAmount money null) 
		
	create table #project_cf (
		ProjectKey int null
		,ObjectFieldSetKey int null
		
		,[Amount_SPLIT_MTHD] varchar(100)
		,GAR varchar(100)
		
		,Amount1 varchar(100)
		,Amount2 varchar(100)
		,Amount3 varchar(100)
		,Amount4 varchar(100)
		,Amount5 varchar(100)
		,Amount6 varchar(100)
		,Amount7 varchar(100)
		,Amount8 varchar(100)
		,Amount9 varchar(100)
		,Amount10 varchar(100)
		
		,AccountCode1 varchar(100)
		,AccountCode2 varchar(100)
		,AccountCode3 varchar(100)
		,AccountCode4 varchar(100)
		,AccountCode5 varchar(100)
		,AccountCode6 varchar(100)
		,AccountCode7 varchar(100)
		,AccountCode8 varchar(100)
		,AccountCode9 varchar(100)
		,AccountCode10 varchar(100)
		
		,SpeedCode1 varchar(100)
		,SpeedCode2 varchar(100)
		,SpeedCode3 varchar(100)
		,SpeedCode4 varchar(100)
		,SpeedCode5 varchar(100)
		,SpeedCode6 varchar(100)
		,SpeedCode7 varchar(100)
		,SpeedCode8 varchar(100)
		,SpeedCode9 varchar(100)
		,SpeedCode10 varchar(100)
		
		)
				
	insert #invoice (InvoiceKey,ClassKey,InvoiceNumber,InvoiceTotalAmount,PostingDate,BillingContactKey)
	select InvoiceKey,ClassKey,InvoiceNumber,InvoiceTotalAmount,PostingDate,PrimaryContactKey
	from   tInvoice (nolock)
	where  CompanyKey = @CompanyKey
	and    Posted = 1
	and    (isnull(InvoiceTotalAmount, 0) 
					- isnull(AmountReceived, 0) 
					- isnull(WriteoffAmount, 0) 
					- isnull(DiscountAmount, 0) 
					- isnull(RetainerAmount, 0)) <> 0
	
	
	-- Pull the Fixed Fee invoice lines, these are ready to go	
	insert #line (InvoiceKey,InvoiceLineKey,ProjectKey,SalesAccountKey,LineClassKey,LineTotalAmount,DetailTotalAmount)
	select il.InvoiceKey, il.InvoiceLineKey, il.ProjectKey, il.SalesAccountKey, il.ClassKey, il.TotalAmount,il.TotalAmount
	from   #invoice  i
	inner  join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey
	where  il.LineType = 2 -- detail line, not a summary line
	and    il.BillFrom = 1 -- Fixed Fee line
	
	-- Pull the Time & Material invoice lines, these must be joined with [vSalesGLDetail]	
	
	-- Requirements are:
	-- Must have one row per invoice, invoice line, project number, line GL class, Sales GL Acct
	
	insert #line (InvoiceKey,InvoiceLineKey,ProjectKey,SalesAccountKey,LineClassKey,LineTotalAmount,DetailTotalAmount)
	select il.InvoiceKey, il.InvoiceLineKey, det.ProjectKey, det.SalesAccountKey,
		 det.ItemClassKey, il.TotalAmount, SUM(det.Amount)
	from   #invoice  i
	inner  join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey
	inner  join vSalesGLDetail det (nolock) on il.InvoiceLineKey = det.InvoiceLineKey
	where  il.LineType = 2 -- detail line, not a summary line
	and    il.BillFrom = 2 -- T&M line
	group by il.InvoiceKey, il.InvoiceLineKey, det.ProjectKey, det.SalesAccountKey,
		 det.ItemClassKey, il.TotalAmount
	
	

	-- get a list of projects
	insert #project_cf (ProjectKey, ObjectFieldSetKey)
	select distinct p.ProjectKey, p.CustomFieldKey
    from   #line
    inner join tProject p (nolock) on #line.ProjectKey = p.ProjectKey
    
	-- Field set for the project CF
	declare @FieldSetKey int
	select @FieldSetKey = FieldSetKey
	from   tFieldSet (nolock)
	where  AssociatedEntity = 'Project'
	and    OwnerEntityKey = @CompanyKey
	
	-- get the custom fields
	update #project_cf
	set    #project_cf.[Amount_SPLIT_MTHD] = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'Amount_SPLIT_MTHD' 
    
    update #project_cf
	set    #project_cf.GAR = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'GAR' 
	
	-- Amount fields
	
	update #project_cf
	set    #project_cf.Amount1 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'Amount1' 
      
    update #project_cf
	set    #project_cf.Amount2 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'Amount2' 
	
	update #project_cf
	set    #project_cf.Amount3 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'Amount3' 
	
	update #project_cf
	set    #project_cf.Amount4 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'Amount4' 
	
	update #project_cf
	set    #project_cf.Amount5 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'Amount5' 
	
	update #project_cf
	set    #project_cf.Amount6 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'Amount6' 
	
	update #project_cf
	set    #project_cf.Amount7 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'Amount7' 
	
	update #project_cf
	set    #project_cf.Amount8 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'Amount8' 
	
	update #project_cf
	set    #project_cf.Amount9 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'Amount9' 
	
	update #project_cf
	set    #project_cf.Amount10 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'Amount10' 
	
	
	-- AccountCode fields
	update #project_cf
	set    #project_cf.AccountCode1 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'AccountCode1' 
	
	update #project_cf
	set    #project_cf.AccountCode2 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'AccountCode2' 
	
	update #project_cf
	set    #project_cf.AccountCode3 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'AccountCode3' 
	
	update #project_cf
	set    #project_cf.AccountCode4 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'AccountCode4' 
	
	update #project_cf
	set    #project_cf.AccountCode5 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'AccountCode5' 
	
	update #project_cf
	set    #project_cf.AccountCode6 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'AccountCode6' 
	
	update #project_cf
	set    #project_cf.AccountCode7 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'AccountCode7' 
	  
	update #project_cf
	set    #project_cf.AccountCode8 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'AccountCode8' 
	
	update #project_cf
	set    #project_cf.AccountCode9 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'AccountCode9' 
	
	update #project_cf
	set    #project_cf.AccountCode10 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'AccountCode10' 
	
	-- SpeedCode fields
	update #project_cf
	set    #project_cf.SpeedCode1 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'SpeedCode1' 
	
	update #project_cf
	set    #project_cf.SpeedCode2 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'SpeedCode2' 
	
	update #project_cf
	set    #project_cf.SpeedCode3 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'SpeedCode3'
	 
	update #project_cf
	set    #project_cf.SpeedCode4 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'SpeedCode4' 
	
	update #project_cf
	set    #project_cf.SpeedCode5 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'SpeedCode5' 
	  
	update #project_cf
	set    #project_cf.SpeedCode6 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'SpeedCode6' 
	  
	update #project_cf
	set    #project_cf.SpeedCode7 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'SpeedCode7' 
  
  	update #project_cf
	set    #project_cf.SpeedCode8 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'SpeedCode8' 

	update #project_cf
	set    #project_cf.SpeedCode9 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'SpeedCode9' 
	  
	update #project_cf
	set    #project_cf.SpeedCode10 = LEFT(val.FieldValue, 100)
	from   tFieldValue val (nolock)
	       inner join tFieldDef  def (nolock) on val.FieldDefKey = def.FieldDefKey
	       inner join tFieldSetField fsf (nolock) on def.FieldDefKey = fsf.FieldDefKey
	where  #project_cf.ObjectFieldSetKey = val.ObjectFieldSetKey
	and    fsf.FieldSetKey = @FieldSetKey
	and    def.FieldName = 'SpeedCode10' 

    -- Final query by joining all tables
	select
	      -- from invoice info 
          i.InvoiceNumber
		  ,i.InvoiceTotalAmount
		  ,i.PostingDate 
		  ,ci.ClassID
		  ,u.FirstName + ' ' + u.LastName as PrimaryContactName 
		  ,u.Email as PrimaryContactEmail
		  
		  -- from line and detail info
          ,l.LineTotalAmount
          ,l.DetailTotalAmount
          ,il.LineSubject
          ,il.LineDescription		  
          ,cl.ClassID as LineClassID
          ,p.ProjectNumber
          ,p.ProjectName
          ,gl.AccountNumber as SalesGLAccountNumber
          ,gl.AccountName as SalesGLAccountName
               
          -- Custom fields    
          ,cf.[Amount_SPLIT_MTHD]
          ,cf.GAR
           
          ,cf.Amount1      
          ,cf.Amount2 
          ,cf.Amount3 
          ,cf.Amount4      
          ,cf.Amount5 
          ,cf.Amount6 
          ,cf.Amount7 
          ,cf.Amount8
          ,cf.Amount9
          ,cf.Amount10
          
          ,cf.AccountCode1      
          ,cf.AccountCode2      
          ,cf.AccountCode3      
          ,cf.AccountCode4      
          ,cf.AccountCode5      
          ,cf.AccountCode6      
          ,cf.AccountCode7      
          ,cf.AccountCode8      
          ,cf.AccountCode9      
          ,cf.AccountCode10
          
          ,cf.SpeedCode1      
          ,cf.SpeedCode2      
          ,cf.SpeedCode3      
          ,cf.SpeedCode4      
          ,cf.SpeedCode5      
          ,cf.SpeedCode6      
          ,cf.SpeedCode7      
          ,cf.SpeedCode8      
          ,cf.SpeedCode9      
          ,cf.SpeedCode10
        
	from  #invoice i
	inner join #line l on i.InvoiceKey = l.InvoiceKey
	inner join tInvoiceLine il (nolock) on l.InvoiceLineKey = il.InvoiceLineKey
	left outer join tUser u (nolock) on i.BillingContactKey = u.UserKey			
	left outer join tClass ci (nolock) on i.ClassKey = ci.ClassKey   		
	left outer join tClass cl (nolock) on l.LineClassKey = cl.ClassKey 
	left outer join tProject p (nolock) on l.ProjectKey = p.ProjectKey  					
	left outer join tGLAccount gl (nolock) on l.SalesAccountKey = gl.GLAccountKey
	left outer join #project_cf cf on l.ProjectKey = cf.ProjectKey
					
	RETURN 1
GO
