USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_CountInvtid]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[EDContainerDet_CountInvtid]
@ContainerID varchar(10)
as
select count(distinct invtid) from edcontainerdet where containerid = @ContainerID
GO
