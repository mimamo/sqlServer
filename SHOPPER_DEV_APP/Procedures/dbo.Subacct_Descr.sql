USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Subacct_Descr]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Subacct_Descr    Script Date: 4/7/98 12:38:59 PM ******/
Create Proc  [dbo].[Subacct_Descr] @parm1 varchar ( 24) as
       Select Descr from Subacct
           where Sub = @parm1
GO
