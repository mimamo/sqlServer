USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjtimhdr_spurge]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjtimhdr_spurge] @parm1 smalldatetime as
select * from pjtimhdr
where pjtimhdr.th_date <= @parm1 and th_status = 'P'
GO
