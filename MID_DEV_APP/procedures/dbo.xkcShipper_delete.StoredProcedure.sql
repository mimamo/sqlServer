USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcShipper_delete]    Script Date: 12/21/2015 14:18:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcShipper_delete] @cpnyid varchar(10)  as
delete from xkcShipper where cpnyid = @cpnyid
GO
