USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRDemandTran_Grid]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRDemandTran_Grid] @InvtID varchar(30),
				  @SiteID varchar(10),
				  @PerPost varchar(6),
				  @RecordIDMin int, @RecordIDMax int
AS
	SELECT * FROM IRDemandTran, INTran
	WHERE
		IRDemandTran.RecordID = INTran.RecordID
		AND IRDemandTran.InvtID = @InvtID
		AND IRDemandTran.SiteID = @SiteID
		AND IRDemandTran.PerPost = @PerPost
		AND IRDemandTran.RecordID BETWEEN @RecordIDMin AND @RecordIDMax
	Order By IRDemandTran.InvtID, IRDemandTran.SiteID, IRDemandTran.PerPost,IRDemandTran.RecordID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
