USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POVendEval_dbnav]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POVendEval_dbnav    Script Date: 12/17/97 10:48:56 AM ******/
Create Procedure [dbo].[POVendEval_dbnav] @parm1 Varchar(10), @Parm2 Varchar(30) as
Select * from POVendReqSum where ReqNbr = @parm1
and Name Like @parm2
Order by ReqNbr, Name
GO
