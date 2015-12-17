USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARAdjust_CustId]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARAdjust_CustId    Script Date: 4/7/98 12:30:32 PM ******/
Create Proc [dbo].[ARAdjust_CustId] @parm1 varchar ( 15) as
    Select * from ARAdjust where custid like @parm1
    order by CustId, AdjdDocType, AdjdRefNbr, AdjgDocDate
GO
