USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjlabhdr_spurge]    Script Date: 12/21/2015 15:43:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjlabhdr_spurge] @parm1 varchar (06) as
select * from pjlabhdr
where pjlabhdr.fiscalno <= @parm1 and le_status = 'P'
GO
