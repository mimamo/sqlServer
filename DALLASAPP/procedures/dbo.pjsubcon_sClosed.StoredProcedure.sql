USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjsubcon_sClosed]    Script Date: 12/21/2015 13:45:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjsubcon_sClosed] @parm1 varchar (16)  as
select * from pjsubcon
where    pjsubcon.project          =    @parm1
and      not pjsubcon.status_sub IN ('C','D',' ')
order by
project
GO
