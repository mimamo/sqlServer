USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmbillrate]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------
-- MAG 8/26/10                                                                                             --
-- Created for Labor Class/Employee Bill Rate Report                                                       --
-- This view was created to retrieve billing rates based on labor class from                               --
-- the PJRATE table using table '0000', rate type 'LB' and rate level '9'                                  --
-- Current view serves as join view for source report view XMEBR00                                         --
------------------------------------------------------------------------------------------------------------------------


CREATE view [dbo].[xmbillrate]

as
select
	a.effect_date bill_effect_date,
	a.rate_key_value1 labor_class,
    a.rate billing_rate
from
	pjrate a
where
    a.rate_table_id = '0000'
and a.rate_type_cd = 'LB'
and a.rate_level = '9'
and	a.effect_date=
(
 select
	max(effect_date)
from
	pjrate
where
	rate_table_id = a.rate_table_id
and rate_type_cd = a.rate_type_cd
and rate_level= a.rate_level
and rate_key_value1 = a.rate_key_value1
)
GO
