USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARAdjust_CustId]    Script Date: 12/21/2015 14:05:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARAdjust_CustId    Script Date: 4/7/98 12:30:32 PM ******/
Create Proc [dbo].[ARAdjust_CustId] @parm1 varchar ( 15) as
    Select * from ARAdjust where custid like @parm1
    order by CustId, AdjdDocType, AdjdRefNbr, AdjgDocDate
GO
