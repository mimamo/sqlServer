USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_sspv]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_sspv] @parm1 varchar (16) , @parm2 varchar (10)  as
select * from pjinvhdr where
project_billwith like @parm1 AND
draft_num Like @parm2
order by draft_num Desc
GO
