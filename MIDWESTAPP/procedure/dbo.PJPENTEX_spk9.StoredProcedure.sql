USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEX_spk9]    Script Date: 12/21/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEX_spk9]  as
select * from PJPENTEX
where project =  'Z'
	  and pjt_entity  =  'Z'
GO
