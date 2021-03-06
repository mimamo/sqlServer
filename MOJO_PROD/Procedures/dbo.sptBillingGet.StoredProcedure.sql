USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGet]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGet]
	@BillingKey int

AS --Encrypt

/*
|| When     Who Rel    What
|| 12/18/06 BSH 8.4    Defaulted the DefaultSalesAccountKey from tPreference.
|| 07/06/07 GHL 8.5    Added GLCompany/office and dept
|| 12/03/08 GHL 10.013 (41656) Users want to see Retainer as billing method for child billing WS
||                     Added ProjectBillingMethod
|| 07/30/09 GHL 10.506 (58703) Added InvoiceNumber to show on screen
|| 02/02/10 MFT 10.518 Added PaymentTerms
|| 04/13/10 GHL 10.521 Added MasterEntityName so that we know what the master was for
|| 07/17/12 GHL 10.558 Added MasterEntityName for billing group codes
|| 08/08/12 GHL 10.558 Added BillingGroupCode to show on UI
|| 09/26/12 GHL 10.560 Changed logic for BillingGroupCode since there is a new table for it
|| 07/30/14 GHL 10.582 (224416) We need to save now the default DepartmentKey in tBillingFixedFee.DefaultDepartmentKey  
||                     because when billing by item, all items may have a different department, on the FF UI
||                     we must have a single default department
|| 12/09/14 MFT 10.5.7 Added ClientName
|| 01/19/15 MFT 10.5.8 Added vUserName/PrimaryContactName, tAddress, tSalesTax/2
|| 03/06/15 WDF 10.590 (239471) Added DefaultARLineFormat
|| 03/27/15 MFT 10.590 Added DefaultSalesAccountName
|| 04/17/15 MFT 10.591 Added LayoutName and ClassName
|| 04/23/15 MFT 10.591 Added join to tProjectRollup
|| 04/29/15 MFT 10.591 Added EstCOGross to EstGross
*/

DECLARE @DepartmentKey INT

SELECT @DepartmentKey = DefaultDepartmentKey
FROM   tBillingFixedFee (NOLOCK)
WHERE  BillingKey = @BillingKey

DECLARE @CompanyKey INT
DECLARE @ParentWorksheet INT
DECLARE @MasterEntity VARCHAR(50)  -- only used for masters
DECLARE @MasterEntityKey INT       -- only used for masters
DECLARE @MasterEntityName VARCHAR(500) -- only used for masters
DECLARE @BillingGroupCode VARCHAR(200) 
DECLARE @BillingGroupKey INT 
DECLARE @BillingGroupEntity VARCHAR(50)

SELECT @MasterEntity = Entity
       ,@MasterEntityKey = EntityKey
       ,@ParentWorksheet = ParentWorksheet
       ,@CompanyKey = CompanyKey
	   ,@BillingGroupKey = case when ParentWorksheet = 1 then EntityKey else GroupEntityKey end
	   ,@BillingGroupEntity = case when ParentWorksheet = 1 then Entity else GroupEntity end 
FROM   tBilling (NOLOCK)
WHERE  BillingKey = @BillingKey

IF @BillingGroupEntity <> 'BillingGroup'
	select @BillingGroupKey = 0

IF isnull(@BillingGroupKey, 0) > 0
	select @BillingGroupCode = BillingGroupCode from tBillingGroup (nolock) where BillingGroupKey = @BillingGroupKey


IF @ParentWorksheet = 1
BEGIN
	IF @MasterEntity IN ( 'Client', 'ParentClient')
	BEGIN
		SELECT @MasterEntityName = ISNULL(CustomerID + '-', '')+ ISNULL(CompanyName, '')
		FROM   tCompany (nolock)
		WHERE  CompanyKey = @MasterEntityKey

		SELECT @MasterEntity = ISNULL(StringSingular, 'Client') 
		FROM   tStringCompany (nolock)
		WHERE  CompanyKey = @CompanyKey
		AND    StringID = 'Client' 
		
		SELECT @MasterEntity = ISNULL(@MasterEntity, 'Client')
		
	END
	ELSE IF @MasterEntity = 'Campaign'
		SELECT @MasterEntityName = ISNULL(CampaignID + '-', '')+ ISNULL(CampaignName, '')
		FROM   tCampaign (nolock)
		WHERE  CampaignKey = @MasterEntityKey
	ELSE IF @MasterEntity = 'RetainerMaster'
		SELECT @MasterEntityName = Title
		      ,@MasterEntity = 'Retainer'
		FROM   tRetainer (nolock)
		WHERE  RetainerKey = @MasterEntityKey
	ELSE IF @MasterEntity = 'Division'
		SELECT @MasterEntityName = DivisionName
		FROM   tClientDivision (nolock)
		WHERE  ClientDivisionKey = @MasterEntityKey
	ELSE IF @MasterEntity = 'Product'
		SELECT @MasterEntityName = ProductName
		FROM   tClientProduct (nolock)
		WHERE  ClientProductKey = @MasterEntityKey
	ELSE IF @MasterEntity = 'BillingGroup'
		SELECT @MasterEntity = 'Billing Group'
		      ,@MasterEntityName = @BillingGroupCode
	ELSE 
		SELECT @MasterEntity = NULL, @MasterEntityName = NULL
	
END
ELSE
	SELECT @MasterEntity = NULL, @MasterEntityName = NULL
	 
		SELECT b.*,
			c.CustomerID as ClientID,
			c.CompanyName AS ClientName,
			c.DefaultARLineFormat AS ClientDefaultARLineFormat,
			pc.UserFullName AS PrimaryContactName,
			a.*,
			p.ProjectNumber,
			p.ProjectName,
			ISNULL(pr.EstGross, 0) + ISNULL(pr.EstCOGross, 0) AS EstimateBudgetAmount,
			cl.ClassID,
			cl.ClassName,
			st1.SalesTaxName AS SalesTax,
			st2.SalesTaxName AS SalesTax2,
			bp.BillingID as ParentBillingID,
			isnull(gl.AccountNumber, 
				(Select AccountNumber 
				 FROM tGLAccount (nolock), tPreference (nolock) 
				 WHERE tGLAccount.GLAccountKey = tPreference.DefaultSalesAccountKey 
				 And b.CompanyKey = tPreference.CompanyKey))  
			 as DefaultSalesAccountNumber,
			isnull(gl.AccountName, 
				(Select AccountName 
				 FROM tGLAccount (nolock), tPreference (nolock) 
				 WHERE tGLAccount.GLAccountKey = tPreference.DefaultSalesAccountKey 
				 And b.CompanyKey = tPreference.CompanyKey))  
			 as DefaultSalesAccountName,
			
			ISNULL((Select Count(*) from tBillingFixedFee (nolock) 
			Where tBillingFixedFee.BillingKey = b.BillingKey), 0)	as FFCount,
			
			ISNULL((Select Percentage from tBillingFixedFee (nolock) 
			Where tBillingFixedFee.BillingKey = b.BillingKey 
			And   tBillingFixedFee.Entity = 'tEstimate'), 0)		as FFBudgetPercentage,

			glc.GLCompanyName,
			o.OfficeName,
			
			@DepartmentKey as DepartmentKey,
			
			ISNULL(p.BillingMethod, 0) AS ProjectBillingMethod,
			
			i.InvoiceNumber ,
			t.TermsDescription,
			l.LayoutName,
			
			@MasterEntityName AS MasterEntityName,
			@MasterEntity AS MasterEntity,
			@BillingGroupCode AS BillingGroupCode,
			@BillingGroupKey AS BillingGroupKey
							
		FROM tBilling b (nolock)
			inner join tCompany c (NOLOCK) on b.ClientKey = c.CompanyKey
			left outer join tProject p (NOLOCK) on b.ProjectKey = p.ProjectKey
			left outer join tClass cl (nolock) on b.ClassKey = cl.ClassKey
			left outer join tBilling bp (nolock) on b.ParentWorksheetKey = bp.BillingKey
			left outer join tGLAccount gl (nolock) on b.DefaultSalesAccountKey = gl.GLAccountKey
			left outer join tGLCompany glc (nolock) on b.GLCompanyKey = glc.GLCompanyKey
			left outer join tOffice o (nolock) on b.OfficeKey = o.OfficeKey	
			left outer join tInvoice i (nolock) on b.InvoiceKey = i.InvoiceKey
			left outer join tPaymentTerms t (nolock) on b.TermsKey = t.PaymentTermsKey
			LEFT JOIN vUserName pc ON b.PrimaryContactKey = pc.UserKey
			LEFT JOIN tAddress a (nolock) ON b.AddressKey = a.AddressKey
			LEFT JOIN tSalesTax st1 (nolock) ON b.SalesTaxKey = st1.SalesTaxKey
			LEFT JOIN tSalesTax st2 (nolock) ON b.SalesTax2Key = st2.SalesTaxKey
			LEFT JOIN tLayout l (nolock) ON b.LayoutKey = l.LayoutKey
			LEFT JOIN tProjectRollup pr (nolock) ON b.ProjectKey = pr.ProjectKey
		WHERE
			b.BillingKey = @BillingKey

	RETURN 1
GO
