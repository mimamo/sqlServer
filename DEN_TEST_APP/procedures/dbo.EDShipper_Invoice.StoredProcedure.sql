USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipper_Invoice]    Script Date: 12/21/2015 15:36:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDShipper_Invoice] @InvcNbr varchar(15) As
Select * From SOShipHeader Where InvcNbr Like @InvcNbr And LTrim(RTrim(InvcNbr)) <> '' Order By InvcNbr
GO
