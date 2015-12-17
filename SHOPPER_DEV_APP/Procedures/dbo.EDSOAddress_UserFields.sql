USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOAddress_UserFields]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOAddress_UserFields] @CustId varchar(15), @ShipToId varchar(10) As
Select User1, User2, User3, User4, User5, User6, User7, User8 From SOAddress Where
CustId = @CustId And ShipToId = @ShipToId
GO
