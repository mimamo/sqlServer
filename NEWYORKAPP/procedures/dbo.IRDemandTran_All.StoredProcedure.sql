USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRDemandTran_All]    Script Date: 12/21/2015 16:01:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRDemandTran_All] @InvtID varchar(30),
				  @SiteID varchar(10),
				  @PerPost varchar(6),
				  @RecordIDMin int, @RecordIDMax int
AS
	SELECT * FROM IRDemandTran
	WHERE
		InvtID = @InvtID
		AND SiteID = @SiteID
		AND PerPost = @PerPost
		AND RecordID BETWEEN @RecordIDMin AND @RecordIDMax
	Order By InvtID, SiteID, PerPost,RecordID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
