USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipper_Invoice]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDShipper_Invoice] @InvcNbr varchar(15) As
Select * From SOShipHeader Where InvcNbr Like @InvcNbr And LTrim(RTrim(InvcNbr)) <> '' Order By InvcNbr
GO
