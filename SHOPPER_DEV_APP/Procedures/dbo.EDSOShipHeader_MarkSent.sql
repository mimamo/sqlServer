USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipHeader_MarkSent]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOShipHeader_MarkSent] @Parm1 varchar(15) As
Update EDSOShipHeader Set OutboundProcNbr = '0', LastEDIDate = GetDate() From EDSOShipHeader A, SOShipHeader B Where
A.ShipperId = B.ShipperId And A.CpnyId = B.CpnyId And B.CustId = @Parm1
GO
