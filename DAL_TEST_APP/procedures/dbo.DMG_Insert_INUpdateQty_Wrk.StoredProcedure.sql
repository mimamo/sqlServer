USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Insert_INUpdateQty_Wrk]    Script Date: 12/21/2015 13:56:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[DMG_Insert_INUpdateQty_Wrk]
	@ComputerName 	varchar(21),
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@Crtd_Prog	varchar(8),
	@Crtd_User	varchar(10)

AS
	IF NOT EXISTS
		(SELECT ComputerName FROM INUpdateQty_Wrk
			WHERE ComputerName = @ComputerName
				and InvtID = @InvtID
				and SiteID = @SiteID
		)
		INSERT INTO INUpdateQty_Wrk
			(ComputerName, InvtID, SiteID,
				Crtd_DateTime, Crtd_Prog, Crtd_User,
				LUpd_DateTime, LUpd_Prog, LUpd_User,
				UpdateWOSupply)
			VALUES
			(@ComputerName, @InvtID, @SiteID,
				Convert(SmallDateTime, GetDate()), @Crtd_Prog, @Crtd_User,
				Convert(SmallDateTime, GetDate()), @Crtd_Prog, @Crtd_User, 1)
GO
