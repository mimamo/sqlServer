USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjexphdr_spurge]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjexphdr_spurge] @parm1 varchar (06) as
select * from pjexphdr
where pjexphdr.fiscalno <= @parm1 and status_1 = 'P'
GO
