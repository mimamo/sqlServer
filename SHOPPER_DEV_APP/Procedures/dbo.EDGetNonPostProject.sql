USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDGetNonPostProject]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDGetNonPostProject] As
Select Control_data From PJContrl Where Control_Code= 'NO-POST-PROJECT'
GO
