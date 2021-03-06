USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDGetLotSerNbr]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDGetLotSerNbr] @InvtId varchar(30) As
Begin Tran
Declare @LotSerNbr char(25)
Select @LotSerNbr = Case LotSerFxdTyp
  When 'C' Then
    LTrim(RTrim(LotSerFxdVal)) + LotSerNumVal
  When 'E' Then
    LTrim(RTrim(LotSerFxdVal)) + LotSerNumVal
  Else
    Substring(Convert(char(30),GetDate(),112 ),5,4) + Substring(Convert(char(30),GetDate(),112 ),1,4) + LotSerNumVal
  End
From Inventory (HoldLock)
Where InvtId = @InvtId
Update Inventory Set LotSerNumVal = Right(Replicate('0',LotSerNumLen) + LTrim(RTrim(Cast(Cast(LotSerNumVal As Int) + 1 As Char(25)))), LotSerNumLen)
Where InvtId = @InvtId
Commit Tran
Select @LotSerNbr
GO
