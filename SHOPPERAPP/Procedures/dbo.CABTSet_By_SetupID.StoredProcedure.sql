USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[CABTSet_By_SetupID]    Script Date: 12/21/2015 16:13:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CABTSet_By_SetupID    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[CABTSet_By_SetupID] @parm1 varchar ( 10) as
Select * from CABTSet
where SetupId like @parm1
Order by setupid, cpnyid, bankacct, banksub
GO
