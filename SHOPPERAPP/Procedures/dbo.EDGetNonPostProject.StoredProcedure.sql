USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDGetNonPostProject]    Script Date: 12/21/2015 16:13:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDGetNonPostProject] As
Select Control_data From PJContrl Where Control_Code= 'NO-POST-PROJECT'
GO
