USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOAddress_CustId_ShipToID]    Script Date: 12/21/2015 16:13:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SOAddress_CustId_ShipToID    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[SOAddress_CustId_ShipToID] @parm1 varchar ( 15), @parm2 varchar ( 10) as
    Select * from SOAddress where CustId = @parm1
                  and ShipToId like @parm2
                  order by CustId, ShipToId
GO
