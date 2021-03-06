USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryGet]
	@JournalEntryKey int = NULL,
	@JournalNumber varchar(50) = NULL,
	@CompanyKey int = NULL

AS --Encrypt

/*
|| When     Who Rel     What
|| 10/16/07 BSH 8.5     (9659)Get GLCompanyName & LineCount. 
|| 01/07/08 GWG 8.51	Made joint to creator a left outer in case they are removed.
|| 12/10/10 RLB 10.539  (96920) pulling down ParentRecurringTranKey
|| 12/28/10 GHL 10.539  (97914) calculating now ParentRecurringTranKey from separate queries
||                       rather than je.RecurringParentKey because for the parent, a tRecurTran 
||                       may exist but je.RecurringParentKey = 0 as long as no recurring trans
||                       has not been created yet
|| 05/23/11 MFT 10.544  Added @JournalNumber and @CompanyKey to get by JournalNumber (validJournalNumber function)
|| 08/06/12 GHL 10.558  (150969) Added GLCompany ID for lookup
|| 09/24/12 RLB 10.560  Added Created By, Created Date and PostedBy
*/

IF ISNULL(@JournalEntryKey, 0) <= 0
	SELECT @JournalEntryKey = JournalEntryKey
	FROM tJournalEntry
	WHERE
		JournalNumber = @JournalNumber AND
		CompanyKey = @CompanyKey
Declare @LineCount int
Declare @Cleared int
If Exists(Select 1 from tTransaction (NOLOCK) Where Entity = 'GENJRNL' And EntityKey = @JournalEntryKey
			And   Cleared = 1 
			)
	Select @Cleared = 1

Select @LineCount = COUNT(*) from tJournalEntryDetail (NOLOCK) Where JournalEntryKey = @JournalEntryKey

declare @RecurringParentKey int    -- JE parent 
declare @ParentRecurringTranKey int -- tRecurTran of the JE parent

select @RecurringParentKey = RecurringParentKey
from   tJournalEntry (nolock)
where  JournalEntryKey = @JournalEntryKey

if isnull(@RecurringParentKey, 0) > 0
	-- if a parent JE exists, get it from the parent
	select @ParentRecurringTranKey = RecurTranKey
	from   tRecurTran (nolock)
	where  Entity = 'GENJRNL'
	and    EntityKey = @RecurringParentKey
else
	-- if no parent JE exists, try to get it from this JE
	select @ParentRecurringTranKey = RecurTranKey
	from   tRecurTran (nolock)
	where  Entity = 'GENJRNL'
	and    EntityKey = @JournalEntryKey


DECLARE @GLCompanyKey int
DECLARE @MultiCurrency int
DECLARE @PostingDate smalldatetime
DECLARE @CurrencyID varchar(10)
DECLARE @ExchangeRate decimal(24,7) -- not the rate on the check header but the one in rate history
DECLARE @RateHistory int

select @CompanyKey = je.CompanyKey
	  ,@GLCompanyKey = isnull(je.GLCompanyKey, 0) 
      ,@CurrencyID = je.CurrencyID
	  ,@PostingDate = je.PostingDate
	  ,@MultiCurrency = isnull(pref.MultiCurrency, 0)
from   tJournalEntry je (nolock)
inner join tPreference pref (nolock) on je.CompanyKey = pref.CompanyKey
where  je.JournalEntryKey = @JournalEntryKey    

-- get the rate history for day/gl comp/curr needed to display on screen
if @MultiCurrency = 1 and isnull(@CurrencyID, '') <> ''
	exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @PostingDate, @ExchangeRate output, @RateHistory output

		SELECT 
			je.*, 
			u.FirstName + ' ' + u.LastName as UserName,
			u2.FirstName + ' ' + u2.LastName as PostedByName,
			je2.JournalNumber as ReversedJournalNumber,
			je3.JournalNumber as ReversingJournalNumber,
			ISNULL(@Cleared, 0) As Cleared,
			glc.GLCompanyID,
			glc.GLCompanyName,
			ISNULL(@LineCount, 0) as LineCount,
			@ParentRecurringTranKey as ParentRecurringTranKey,
			@RateHistory as RateHistory
			--rt.RecurTranKey as ParentRecurringTranKey
		FROM tJournalEntry je (nolock)
			left outer join tUser u (nolock) on je.EnteredBy = u.UserKey
			left outer join tGLCompany glc (nolock) on je.GLCompanyKey = glc.GLCompanyKey
			left outer join tJournalEntry je2 (nolock) on je.JournalEntryKey = je2.ReversingEntry
			left outer join tJournalEntry je3 (nolock) on je.ReversingEntry = je3.JournalEntryKey
			--left outer join tRecurTran rt (nolock) on je.RecurringParentKey = rt.EntityKey and rt.Entity = 'GENJRNL'
			left outer join tUser u2 (nolock) on je.PostedByKey = u2.UserKey
		WHERE
			je.JournalEntryKey = @JournalEntryKey

	RETURN 1
GO
