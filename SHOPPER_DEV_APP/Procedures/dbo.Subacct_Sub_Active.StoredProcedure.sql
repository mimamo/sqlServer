USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Subacct_Sub_Active]    Script Date: 12/21/2015 14:34:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Subacct_Sub_Active    Script Date: 4/7/98 12:38:59 PM ******/
Create Proc  [dbo].[Subacct_Sub_Active] @parm1 varchar ( 24) as
       Select * from Subacct
           where Sub     LIKE  @parm1
             and Active  =      1
           order by Sub
GO
