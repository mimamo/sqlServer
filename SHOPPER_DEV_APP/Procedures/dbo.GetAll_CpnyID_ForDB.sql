USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GetAll_CpnyID_ForDB]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GetAll_CpnyID_ForDB]
	@DatabaseName	varchar(30)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	Select CpnyID
	from vs_Company
	where DatabaseName = @DatabaseName
GO
