USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xvr_LABCDesc]    Script Date: 12/21/2015 13:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xvr_LABCDesc]

as

select 
rtrim(code_value) as 'LABC', 
rtrim(code_value_desc) as 'LABCDesc'
from pjcode 
where 
code_type='LABC'
GO
