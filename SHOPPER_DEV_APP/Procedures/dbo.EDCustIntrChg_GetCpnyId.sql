USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCustIntrChg_GetCpnyId]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCustIntrChg_GetCpnyId] @Id varchar(15), @Qualifier varchar(2), @EDIBillToRef varchar(80) As
Declare @CpnyId varchar(10)
Select @CpnyId = CpnyId From EDCustIntrChg Where Id = @Id And Qualifier = @Qualifier And EDIBillToRef = @EDIBillToRef
If IsNull(@CpnyId,'~') = '~'
  Select @CpnyId = CpnyId From EDCustIntrChg Where Id = @Id And Qualifier = @Qualifier And LTrim(EDIBillToRef) = ''
Select @CpnyId
GO
