USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CABTSet_By_SetupID]    Script Date: 12/16/2015 15:55:15 ******/
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
