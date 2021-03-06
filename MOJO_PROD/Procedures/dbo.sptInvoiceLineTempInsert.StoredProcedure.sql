USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineTempInsert]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineTempInsert]
 @InvoiceLineKey int,
 @ProjectKey int,
 @TaskKey int, 
 @LineType smallint,
 @LineSubject varchar(100),
 @LineDescription text,
 @BillFrom smallint,
 @PostSalesUsingDetail tinyint,
 @Quantity decimal(24,4),
 @UnitAmount money,
 @TotalAmount money,
 @SalesAccountKey int,
 @ClassKey int,

 @LineLevel int,
 @DisplayOrder int,
 @InvoiceOrder int,
 @ParentLineKey int,
 
 @Taxable tinyint,
 @Taxable2 tinyint,
 @WorkTypeKey int,
 @Entity varchar(100),
 @EntityKey int,
 @RetainerKey int,
 @EstimateKey int,
 @OfficeKey int,
 @DepartmentKey int,
 @SalesTaxAmount money,
 @SalesTax1Amount money,
 @SalesTax2Amount money,
 @DisplayOption smallint,
 @CampaignSegmentKey int,
 @TargetGLCompanyKey int,
 @Action varchar(50)

AS --Encrypt

/*
|| When     Who Rel      What
|| 09/08/10 GHL 10.534   Creation for flex invoice screen 
|| 05/17/11 GHL 10.544   Added cleanup of EntityKey to help with import
|| 03/27/12 GHL 10.554   Added @TargetGLCompanyKey
|| 05/14/13 GHL 10.568   Added fields to reset when LineType = 1--summary, Quantity=1, etc..
|| 03/20/15 GHL 10.591   For summary lines, take quantity = 0 because Abelson Taylor displays quantities for T&M lines
||                       It has to be 0 for summary lines to look good on layouts
||                       Also Entity can be tTitle now
*/

-- if summary line, all amounts are zero
if @LineType = 1
	select @TotalAmount = 0, @SalesTaxAmount = 0, @SalesTax1Amount = 0, @SalesTax2Amount = 0, @Quantity = 0, @UnitAmount = 0, @Taxable = 0, @Taxable2=0

if @Entity not in ('tItem', 'tService', 'tTitle')
	select @Entity = null
	      ,@EntityKey = null
   
if @TargetGLCompanyKey = 0
	select @TargetGLCompanyKey = null

INSERT #tInvoiceLine
  (
 InvoiceLineKey,
 ProjectKey,
 TaskKey , 
 LineType ,
 LineSubject ,
 LineDescription ,
 BillFrom ,
 PostSalesUsingDetail ,
 Quantity ,
 UnitAmount ,
 TotalAmount ,
 SalesAccountKey ,
 ClassKey ,

 LineLevel ,
 DisplayOrder ,
 InvoiceOrder ,
 ParentLineKey ,
 
 Taxable ,
 Taxable2 ,
 WorkTypeKey ,
 Entity ,
 EntityKey ,
 RetainerKey ,
 EstimateKey ,
 OfficeKey ,
 DepartmentKey ,
 SalesTaxAmount ,
 SalesTax1Amount ,
 SalesTax2Amount ,
 DisplayOption ,
 CampaignSegmentKey,
 TargetGLCompanyKey,

 UpdateFlag, 
 Action
  )
 VALUES
  (
 @InvoiceLineKey,
 @ProjectKey,
 @TaskKey , 
 @LineType ,
 @LineSubject ,
 @LineDescription ,
 @BillFrom ,
 @PostSalesUsingDetail ,
 @Quantity ,
 @UnitAmount ,
 @TotalAmount ,
 @SalesAccountKey ,
 @ClassKey ,

 @LineLevel ,
 @DisplayOrder ,
 @InvoiceOrder ,
 @ParentLineKey ,
 
 @Taxable ,
 @Taxable2 ,
 @WorkTypeKey ,
 @Entity ,
 @EntityKey ,
 @RetainerKey ,
 @EstimateKey ,
 @OfficeKey ,
 @DepartmentKey ,
 @SalesTaxAmount ,
 @SalesTax1Amount ,
 @SalesTax2Amount ,
 @DisplayOption ,
 @CampaignSegmentKey,
 @TargetGLCompanyKey,
 
 0, 
 @Action
  )

  RETURN 1
GO
