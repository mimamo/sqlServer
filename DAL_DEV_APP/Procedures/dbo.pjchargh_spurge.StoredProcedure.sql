USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjchargh_spurge]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjchargh_spurge] @parm1 varchar (06) as
select * from pjchargh
where pjchargh.fiscalno <= @parm1 and batch_status = 'P'
GO
