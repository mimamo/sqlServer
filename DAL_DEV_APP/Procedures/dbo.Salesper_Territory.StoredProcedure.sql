USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Salesper_Territory]    Script Date: 12/21/2015 13:35:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Salesper_Territory    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[Salesper_Territory] @parm1 varchar ( 10) as
    Select * from Salesperson where Territory = @parm1 order by SlsperId
GO
