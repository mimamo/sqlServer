USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SIUserAppAuth_All]    Script Date: 12/21/2015 15:43:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[SIUserAppAuth_All] @Parm1 varchar(47) as
    Select * from SIUserAppAuth Where UserID like @Parm1
	Order by UserID
GO
