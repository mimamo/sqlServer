USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_sProj]    Script Date: 12/21/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjinvdet_sProj]  @parm1 varchar (16)   as
select * from pjinvdet
where    project     =   @parm1
GO
