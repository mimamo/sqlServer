USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARHist_CustID]    Script Date: 12/21/2015 14:34:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARHist_CustID    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[ARHist_CustID] @parm1 varchar ( 15) as
       Select * from ARHist
           where CustId like @parm1
           order by CustID
GO
