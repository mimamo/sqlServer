USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Salesper_SlsperId]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Salesper_SlsperId    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[Salesper_SlsperId] @parm1 varchar ( 10) as
    Select * from Salesperson where SlsperId like @parm1 order by SlsperId
GO
