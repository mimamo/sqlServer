USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PP_01270]    Script Date: 12/21/2015 16:01:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PP_01270] @Company Varchar ( 10)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
Begin Tran

Delete from VS_SubXRef where cpnyid = @Company

Insert into VS_SubXRef (Active, CpnyId , Descr, Sub, User1, User2, User3, User4)
         Select Active, @company, Descr, Sub, User1, User2, User3, User4 from Subacct
Commit
GO
