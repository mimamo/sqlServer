USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDGetNonPostProject]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDGetNonPostProject] As
Select Control_data From PJContrl Where Control_Code= 'NO-POST-PROJECT'
GO
