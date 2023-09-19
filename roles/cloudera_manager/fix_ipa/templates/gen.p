--- gen.orig	2023-09-19 00:17:14.950431672 -0700
+++ gen.patched	2023-09-19 00:24:48.901447515 -0700
@@ -49,7 +49,11 @@
   echo "Host $HOST exists"
 else
   echo "Adding new host: $HOST"
-  ipa host-add $HOST --force --no-reverse
+  if [[ $HOST =~ \. ]]; then
+    ipa host-add $HOST --force --no-reverse
+  else 
+    ipa host-add $HOST.{{ cluster_name }}  --force --no-reverse
+  fi
 fi
 
 set +e
@@ -62,7 +66,11 @@
 else
   PRINC_EXISTS=no
   echo "Adding new principal: $PRINCIPAL"
-  ipa service-add $PRINCIPAL --force
+  if [[ $PRINCIPAL =~ \. ]]; then
+    ipa service-add $PRINCIPAL --force
+  else
+    ipa service-add $PRINCIPAL.{{ cluster_name }} --force
+  fi
 fi
 
 # Set the maxrenewlife for the principal, if given. There is no interface
@@ -110,4 +118,4 @@
 fi
 
 kdestroy
-exit 0
\ No newline at end of file
+exit 0
