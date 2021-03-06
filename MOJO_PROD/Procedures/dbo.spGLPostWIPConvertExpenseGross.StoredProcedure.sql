USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIPConvertExpenseGross]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostWIPConvertExpenseGross]
	(
	@CompanyKey int
	,@UserKey int
	)
AS --Encrypt

/*
|| When     Who Rel      What
|| 10/24/10 GHL 10.537   Creation for new WIP functionality
|| 12/20/10 GHL 10.539   Changed JE # to wip rev convert
||                       
*/


	SET NOCOUNT ON

Declare @GLClosedDate smalldatetime
Declare @PostToGL tinyint
Declare @WIPLaborAssetAccountKey int
Declare @WIPLaborIncomeAccountKey int
Declare @WIPLaborWOAccountKey int
Declare @WIPExpenseAssetAccountKey int
Declare @WIPExpenseIncomeAccountKey int
Declare @WIPExpenseWOAccountKey int
Declare @WIPMediaAssetAccountKey int
Declare @WIPMediaIncomeAccountKey int
Declare @WIPMediaWOAccountKey int
Declare @WIPVoucherAssetAccountKey int
Declare @WIPVoucherIncomeAccountKey int
Declare @WIPVoucherWOAccountKey int
Declare @WIPClassFromDetail int
Declare @WIPBookVoucherToRevenue int
Declare @IOClientLink int -- 1 Link by project, 2 by Media Estimate
Declare @BCClientLink int
Declare @Overhead tinyint
Declare @UseGLCompany tinyint

Select
	@GLClosedDate = GLClosedDate,
	
	-- Labor accounts
	@WIPLaborAssetAccountKey = ISNULL(WIPLaborAssetAccountKey, 0),
	@WIPLaborIncomeAccountKey = ISNULL(WIPLaborIncomeAccountKey, 0),
	@WIPLaborWOAccountKey = ISNULL(WIPLaborWOAccountKey, 0),
	
	-- Misc Costs and ERs accounts
	@WIPExpenseAssetAccountKey = ISNULL(WIPExpenseAssetAccountKey, 0),
	@WIPExpenseIncomeAccountKey = ISNULL(WIPExpenseIncomeAccountKey, 0),
	@WIPExpenseWOAccountKey = ISNULL(WIPExpenseWOAccountKey, 0),
	
	@WIPBookVoucherToRevenue = ISNULL(WIPBookVoucherToRevenue, 0),

	-- Media Voucher accounts
	@WIPMediaAssetAccountKey = ISNULL(WIPMediaAssetAccountKey, 0),
	@WIPMediaIncomeAccountKey = ISNULL(WIPMediaIncomeAccountKey, 0),
	@WIPMediaWOAccountKey = ISNULL(WIPMediaWOAccountKey, 0),
	
	-- Production Voucher accounts
	@WIPVoucherAssetAccountKey = ISNULL(WIPVoucherAssetAccountKey, 0),
	@WIPVoucherIncomeAccountKey = ISNULL(WIPVoucherIncomeAccountKey, 0),
	@WIPVoucherWOAccountKey = ISNULL(WIPVoucherWOAccountKey, 0),
	
	-- Flags
	@PostToGL = ISNULL(PostToGL, 0),
	@WIPClassFromDetail = ISNULL(WIPClassFromDetail, 0),
	@IOClientLink = ISNULL(IOClientLink, 1),
	@BCClientLink = ISNULL(BCClientLink, 1),
	@UseGLCompany = ISNULL(UseGLCompany, 0)	
from tPreference  (nolock)
Where CompanyKey = @CompanyKey


	create table #wip (Entity varchar(20) null
						,EntityKey int null
						,ExpenseAccountKey int null
						,BillableCost money null
						
						,ProjectKey int null
						,ClientKey int null
						,ClassKey int null
						,GLCompanyKey int null
						,OfficeKey int null
						,DepartmentKey int null

						,ItemType int null
						,WIPAmount money null
						)

	-- ClientKey, ClassKey, OfficeKey, DepartmentKey ??? GLCompanyKey???
	create table #jed (GLAccountKey int null
						,Entity varchar(20) null
						,Memo varchar(500) null
						,DebitAmount money null
						,CreditAmount money null
						
						,ProjectKey int null
						,ClientKey int null
						,ClassKey int null
						,GLCompanyKey int null
						,OfficeKey int null
						,DepartmentKey int null

						,ItemType int null
						,PostSide char(1) null 
						,DiffGrossNet money null -- Gross - Net
						)


	-- VDs went in against the Expense account on the line
	insert #wip (Entity, EntityKey, ExpenseAccountKey, BillableCost, ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey,ItemType, WIPAmount)
	select  'tVoucherDetail', vd.VoucherDetailKey, vd.ExpenseAccountKey, vd.BillableCost 
	,vd.ProjectKey, vd.ClientKey, vd.ClassKey, v.GLCompanyKey, vd.OfficeKey, vd.DepartmentKey 
	,isnull(i.ItemType, 0), isnull(vd.OldWIPAmount, vd.WIPAmount)
	from    tVoucherDetail vd (nolock)
		inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
	where v.CompanyKey = @CompanyKey
	and  vd.WIPPostingInKey > 0 -- check for negative values here?
	and  vd.WIPPostingOutKey = 0
	
	-- Misc Costs went in against @WIPExpenseIncomeAccountKey
	insert #wip (Entity, EntityKey, ExpenseAccountKey, BillableCost, ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType, WIPAmount)
	select  'tMiscCost', mc.MiscCostKey, @WIPExpenseIncomeAccountKey,mc.BillableCost
	,mc.ProjectKey, p.ClientKey, mc.ClassKey, p.GLCompanyKey, p.OfficeKey, mc.DepartmentKey 
	, 0, isnull(mc.OldWIPAmount, mc.WIPAmount)
	from    tMiscCost mc (nolock)
		inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey
	where p.CompanyKey = @CompanyKey
	and  mc.WIPPostingInKey > 0 -- check for negative values here?
	and  mc.WIPPostingOutKey = 0


	update #wip 
	set ProjectKey = isnull(ProjectKey, 0)
	   ,ClientKey = isnull(ClientKey, 0)
	   ,ClassKey = isnull(ClassKey, 0)
	   ,GLCompanyKey = isnull(GLCompanyKey, 0)
	   ,OfficeKey = isnull(OfficeKey, 0)
	   ,DepartmentKey = isnull(DepartmentKey, 0)

   
	/*
	VoucherDetail

    Asset
    ------
    100|

    Expense
    -------
	   | 100

    we must do

    Expense
    -------
	100 |         <-- reversal

    Income
    --------
        |110

    Asset
    ------
    10 |


	MiscCost

    Asset
    ------
    100|

    Income
    -------
	   | 100

    income
    -------
	100 |     <------reversal

    Income
    --------
        |110

    Asset
    ------
    10 |


	*/

	--1) Debit the expense account at NET
	--------------------------------------

	-- here the Entity does not matter 
	insert 	#jed (GLAccountKey, DebitAmount, CreditAmount, PostSide, ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType)
	select  ExpenseAccountKey, SUM(WIPAmount), 0, 'D', ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType
	from    #wip
	group by ExpenseAccountKey, ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType
	 
	--2) Credit the income account at GROSS
	-------------------------------------
	 
	insert 	#jed (GLAccountKey, Entity, DebitAmount, CreditAmount, PostSide, ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType)
	select  @WIPMediaIncomeAccountKey, 'tVoucherDetail', 0, SUM(BillableCost), 'C', ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType
	from    #wip
	where   ItemType in (1,2) -- media
	--and     Entity = 'tVoucherDetail'
	group by  ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType
	
	insert 	#jed (GLAccountKey, Entity, DebitAmount, CreditAmount, PostSide, ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType)
	select  @WIPVoucherIncomeAccountKey, 'tVoucherDetail', 0, SUM(BillableCost), 'C', ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType
	from    #wip
	where   ItemType = 0 -- production
	and     Entity = 'tVoucherDetail'
	group by  ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType

	insert 	#jed (GLAccountKey, Entity, DebitAmount, CreditAmount, PostSide, ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType)
	select  @WIPExpenseIncomeAccountKey, 'tVoucherDetail', 0, SUM(BillableCost), 'C', ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType
	from    #wip
	where   ItemType = 3 -- Exp Receipts on VD
	and     Entity = 'tVoucherDetail'
	group by  ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType
	
	-- misc costs
	insert 	#jed (GLAccountKey, Entity, DebitAmount, CreditAmount, PostSide, ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType)
	select  @WIPExpenseIncomeAccountKey, 'tMiscCost', 0, SUM(BillableCost), 'C', ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType 
	from    #wip
	where   Entity = 'tMiscCost'
	group by  Entity, ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType

	--3) Debit Asset account with Gross - Net
	--------------------------------------
	
	-- capture Net
	update #jed
	set    #jed.DiffGrossNet = (select sum(w.WIPAmount)
		from #wip w
		where w.Entity  = #jed.Entity
		and   w.ProjectKey  = #jed.ProjectKey
		and   w.ClientKey  = #jed.ClientKey
		and   w.ClassKey  = #jed.ClassKey
		and   w.GLCompanyKey  = #jed.GLCompanyKey
		and   w.OfficeKey  = #jed.OfficeKey
		and   w.DepartmentKey  = #jed.DepartmentKey

		and   w.ItemType = #jed.ItemType
		)
	where #jed.PostSide = 'C'

	update #jed
	set    #jed.DiffGrossNet = isnull(CreditAmount,0) - isnull(DiffGrossNet,0) 
	where  #jed.PostSide = 'C'
	
	 
	insert #jed (GLAccountKey, Entity, DebitAmount, CreditAmount, PostSide, ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType)
	select @WIPExpenseAssetAccountKey, 'tMiscCost2', DiffGrossNet, 0, 'D', ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType 
	from   #jed 
	where  #jed.Entity = 'tMiscCost'
	and    #jed.PostSide = 'C'
	 
	insert #jed (GLAccountKey, Entity, DebitAmount, CreditAmount, PostSide, ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType)
	select 
		case 
			when ItemType = 0 then @WIPVoucherAssetAccountKey
			when ItemType = 1 then @WIPMediaAssetAccountKey
			when ItemType = 2 then @WIPMediaAssetAccountKey
			when ItemType = 3 then @WIPExpenseAssetAccountKey
		end
		, 'tVoucherDetail2', DiffGrossNet, 0, 'D', ProjectKey, ClientKey, ClassKey, GLCompanyKey, OfficeKey, DepartmentKey, ItemType 
	from   #jed 
	where  #jed.Entity = 'tVoucherDetail'
	and    #jed.PostSide = 'C'

	delete from #jed where isnull(DebitAmount, 0) = 0 and isnull(CreditAmount, 0) = 0 

	--select sum(DebitAmount) from #jed
	--select sum(CreditAmount) from #jed

	--select * from #wip
	--select * from #jed

	update #jed set #jed.ProjectKey = null where #jed.ProjectKey = 0 
	update #jed set #jed.ClassKey = null where #jed.ClassKey = 0 
	update #jed set #jed.ClientKey = null where #jed.ClientKey = 0 
	update #jed set #jed.OfficeKey = null where #jed.OfficeKey = 0 
	update #jed set #jed.DepartmentKey = null where #jed.DepartmentKey = 0 

	declare @RetVal int 
	declare @GLCompanyKey int 
	declare @JEGLCompanyKey int 
	declare @JournalEntryKey int
	declare @JEDate smalldatetime
	declare @NextJournalNumber varchar(50)
	declare @JNCount int
	declare @Description varchar(1000)

	select @JEDate = convert(smalldatetime, (convert(varchar(10), getdate(), 101)), 101)
	select @Description = 'Journal Entry created to convert WIP entries from Net to Gross'
	
	select @JNCount = count(*) + 1
	from   tJournalEntry (nolock) where CompanyKey = @CompanyKey
	and    JournalNumber like 'wip rev convert%'

	select @GLCompanyKey = -1
	while (1=1)
	begin
		select @GLCompanyKey = min(GLCompanyKey)
		from   #jed
		where  GLCompanyKey > @GLCompanyKey

		if @GLCompanyKey is null
			break

		if @GLCompanyKey = 0
			select @JEGLCompanyKey = null
		else
			select @JEGLCompanyKey = @GLCompanyKey

		--select @NextJournalNumber = NextJournalNumber from tPreference (nolock) where CompanyKey = @CompanyKey

		if @JNCount = 1
			select @NextJournalNumber = 'wip rev convert'
		else
			select @NextJournalNumber = 'wip rev convert ' + cast (@JNCount as varchar(50)) 

		select @JNCount = @JNCount + 1

		exec @RetVal = sptJournalEntryInsert @CompanyKey, @JEDate, @JEDate, @UserKey, @NextJournalNumber, @Description, 0, @JEGLCompanyKey, 1, 0, @JournalEntryKey output

		if (@RetVal <= 0) 
			return @RetVal

		if (@RetVal > 0)
		begin
			insert tJournalEntryDetail (JournalEntryKey, GLAccountKey, ClientKey, ClassKey, DebitAmount, CreditAmount, ProjectKey, OfficeKey, DepartmentKey, Memo)
			select @JournalEntryKey, GLAccountKey, ClientKey, ClassKey, DebitAmount, CreditAmount, ProjectKey, OfficeKey, DepartmentKey
				,case when Entity is null then 'Reversal of current WIP entries (expense or income)'
				     when PostSide = 'C' then 'Credits to Income Accounts'
					 when Entity is not null and PostSide = 'D'	then 'Adjustment to WIP asset entries'
				end
			from   #jed 
			where  GLCompanyKey = @GLCompanyKey 
		end

	end

	-- save the Old WIPAmount, in case users do this several times, check if OldWIPAmount is null first

	update tVoucherDetail 
	set    tVoucherDetail.OldWIPAmount = #wip.WIPAmount
	from   #wip
		   ,tVoucher v (nolock)
	where  #wip.Entity = 'tVoucherDetail'
	and    tVoucherDetail.VoucherDetailKey = #wip.EntityKey
	and    tVoucherDetail.VoucherKey = v.VoucherKey
	and    v.CompanyKey = @CompanyKey
	and    tVoucherDetail.OldWIPAmount is null
	 
	update tMiscCost 
	set    tMiscCost.OldWIPAmount = #wip.WIPAmount
	from   #wip
		   ,tProject p (nolock)
	where  #wip.Entity = 'tMiscCost'
	and    tMiscCost.MiscCostKey = #wip.EntityKey
	and    tMiscCost.ProjectKey = p.ProjectKey
	and    p.CompanyKey = @CompanyKey
	and    tMiscCost.OldWIPAmount is null

	-- Now save the New WIPAmount

	update tVoucherDetail 
	set    tVoucherDetail.WIPAmount = #wip.BillableCost
	from   #wip
		   ,tVoucher v (nolock)
	where  #wip.Entity = 'tVoucherDetail'
	and    tVoucherDetail.VoucherDetailKey = #wip.EntityKey
	and    tVoucherDetail.VoucherKey = v.VoucherKey
	and    v.CompanyKey = @CompanyKey

	update tMiscCost 
	set    tMiscCost.WIPAmount = #wip.BillableCost
	from   #wip
		   ,tProject p (nolock)
	where  #wip.Entity = 'tMiscCost'
	and    tMiscCost.MiscCostKey = #wip.EntityKey
	and    tMiscCost.ProjectKey = p.ProjectKey
	and    p.CompanyKey = @CompanyKey
	
	RETURN 1
GO
