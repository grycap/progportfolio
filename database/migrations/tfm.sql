-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-12-2016 a las 19:32:36
-- Versión del servidor: 5.6.11
-- Versión de PHP: 5.5.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `tfm`
--
CREATE DATABASE IF NOT EXISTS `tfm` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `tfm`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `credentials`
--

CREATE TABLE IF NOT EXISTS `credentials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(256) NOT NULL,
  `imuser` varchar(256) DEFAULT NULL,
  `type` varchar(256) DEFAULT NULL,
  `host` varchar(256) DEFAULT NULL,
  `username` varchar(256) DEFAULT NULL,
  `password` varchar(256) DEFAULT NULL,
  `enabled` int(11) DEFAULT NULL,
  `ord` int(11) DEFAULT NULL,
  `proxy` text,
  `token_type` varchar(256) DEFAULT NULL,
  `project` varchar(256) DEFAULT NULL,
  `public_key` text,
  `private_key` text,
  `certificate` text,
  `tenant` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Volcado de datos para la tabla `credentials`
--

INSERT INTO `credentials` (`id`, `nombre`, `imuser`, `type`, `host`, `username`, `password`, `enabled`, `ord`, `proxy`, `token_type`, `project`, `public_key`, `private_key`, `certificate`, `tenant`) VALUES
(1, '', 'admin', 'VMRC', 'http://servproject.i3m.upv.es:8080/vmrc/vmrc', 'micafer', 'ttt25', 1, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, '', 'admin', 'InfrastructureManager', '', 'admin', 'admin', 1, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `radls`
--

CREATE TABLE IF NOT EXISTS `radls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_recipe` int(11) NOT NULL,
  `imuser` varchar(128) NOT NULL,
  `name` varchar(128) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `radl` text NOT NULL,
  `central` text NOT NULL,
  `student` text NOT NULL,
  `language` varchar(10) DEFAULT NULL,
  `type` int(2) NOT NULL,
  `validate` varchar(5) NOT NULL DEFAULT 'false',
  `response` text NOT NULL,
  `id_deploy` varchar(100) NOT NULL,
  `count_central` int(2) NOT NULL DEFAULT '1',
  `count_student` int(2) NOT NULL DEFAULT '0',
  `finish` int(2) NOT NULL DEFAULT '0',
  `finish_date` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `msg` text NOT NULL,
  `msg_error` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_recipe` (`id_recipe`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recipe`
--

CREATE TABLE IF NOT EXISTS `recipe` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `radl` text NOT NULL,
  `language` varchar(10) DEFAULT NULL,
  `type` int(2) NOT NULL DEFAULT '1',
  `validate` varchar(5) NOT NULL DEFAULT 'false',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Volcado de datos para la tabla `recipe`
--

INSERT INTO `recipe` (`id`, `name`, `description`, `radl`, `language`, `type`, `validate`, `created_at`, `updated_at`) VALUES
(11, 'Receta Java Central', 'Esta receta es una receta base para 1 maquina central', '@puertos@\nnetwork privada ()\n@configuracion@\n\nconfigure central (\n@begin\n---\n  - vars:\n      @cuentas@\n      home: /home/ubuntu/\n      baseurl: https://master-class:master-password@bitbucket.org/phantro/base-java.git\n      ipmaster: localhost\n      jenkinsnode: /home/ubuntu/node-jenkins\n      jenkinsnodeurl: https://master-class:master-password@bitbucket.org/phantro/node-jenkins.git\n      jenkinsserver: https://master-class:master-password@bitbucket.org/phantro/jenkins-server.git\n      jenkins: /home/ubuntu/jenkins-server\n      userproyect: proyect-user.sh\n\n    tasks:\n    - name: Install Git 0f485338872\n      apt: name=git update_cache=yes state=latest\n\n    - name: Install Curl\n      apt: name=curl update_cache=yes state=latest\n\n    - name: Update repository Node.js\n      shell: ''curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -''\n\n    - name: Install Node.js\n      apt: name=nodejs update_cache=yes state=latest\n\n    - name: Install Dependency Node.js\n      apt: name=build-essential update_cache=yes state=latest\n\n    - name: Create user accounts student\n      user: name={{ item.name }} password={{ item.pw }} shell=/bin/bash\n      with_items: accounts\n\n    - name: Modify $HOME permissions student\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700\n      with_items: accounts\n\n    - name: Create user admin\n      user: name={{ item.name }} password={{ item.pw }} shell=/bin/bash\n      with_items: admin\n\n    - name: Modify $HOME permissions admin\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700\n      with_items: admin\n\n    - lineinfile: dest=/etc/ssh/sshd_config regexp="PasswordAuthentication no" line="PasswordAuthentication no" state=absent\n    - lineinfile: dest=/etc/ssh/sshd_config regexp="PasswordAuthentication yes" line="PasswordAuthentication yes" state=present\n    - service: name=ssh state=restarted\n\n    - name: Add sudo admin\n      shell: ''adduser {{ item.name }} sudo''\n      with_items: admin\n\n    - name: Install Openssh\n      apt: name=openssh-server update_cache=yes state=latest\n    - name: Install Certificates\n      apt: name=ca-certificates update_cache=yes state=latest\n    - name: Update repository sh\n      shell: ''curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash''\n    - name: Install Gitlab\n      apt: name=gitlab-ce update_cache=yes state=latest\n\n    - name: Initial Gitlab\n      shell: ''gitlab-ctl reconfigure''\n\n    - name: App | Cloning repos + backup proyect\n      git: repo={{ jenkinsnodeurl }}\n           dest={{ item.dest }}\n           accept_hostkey=yes\n           force=yes\n           recursive=no\n      with_items:\n        -\n          dest: "{{ jenkinsnode }}"\n          repo: PrimaryRepo\n\n    - copy: dest={{ jenkinsnode }}/user.json content=''@cuentasUsuarioJson@''\n\n    - copy: dest={{ jenkinsnode }}/repository.json content=''@cuentasGit@''\n\n    - name: Add repo for java 8 0f168424895\n      apt_repository: repo=''ppa:openjdk-r/ppa'' state=present\n\n    - name: Install java 8\n      apt: name=openjdk-8-jdk state=latest update-cache=yes force=yes\n      sudo: yes\n\n    - lineinfile: dest=/etc/bash.bashrc regexp="export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" line="export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" create=yes\n\n    - name: App | Cloning repos + submodules + jenkins 0f452458482\n      git: repo={{jenkinsserver}}\n           dest={{ item.dest }}\n           accept_hostkey=yes\n           force=yes\n           recursive=no\n      with_items:\n        -\n          dest: "{{ jenkins }}"\n          repo: PrimaryRepo\n\n    - name: Download Maven\n      get_url: url=http://archive.apache.org/dist/maven/binaries/apache-maven-3.0.4-bin.tar.gz dest={{home}}\n\n    - name: Unarchive maven\n      unarchive: src={{home}}apache-maven-3.0.4-bin.tar.gz dest={{home}} copy=no\n\n    - name: Delete Apache.tar.gz\n      file: path={{home}}apache-maven-3.0.4-bin.tar.gz state=absent recurse=no\n\n    - command: mv {{home}}apache-maven-3.0.4 /usr/local\n\n    - name: Run Maven\n      shell: ''sudo ln -s /usr/local/apache-maven-3.0.4/bin/mvn /usr/bin/mvn''\n\n    - name: Download Sonar\n      get_url: url=https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-4.5.7.zip dest={{home}}\n\n    - name: Install unzip\n      apt: pkg=unzip state=latest update_cache=yes\n\n    - name: Unarchive Sonar\n      unarchive: src={{home}}sonarqube-4.5.7.zip dest={{home}} copy=no\n\n    - name: Delete Sonar.zip\n      file: path={{home}}sonarqube-4.5.7.zip state=absent recurse=no\n\n    - name: Run Sonar\n      shell: ''cd {{home}}sonarqube-4.5.7 && bin/linux-x86-64/sonar.sh console &''\n\n    - command: /bin/sleep 180\n\n    - name: Run Jenkins\n      shell: ''{{jenkins}}/jenkins.sh start''\n\n    - command: /bin/sleep 180\n\n    - name: Install codeblocks\n      apt: name=codeblocks update_cache=yes state=latest\n\n    - name: Install lxde\n      apt: name=lxde update_cache=yes state=latest\n\n    - name: Run lxdm\n      shell: ''start lxdm''\n\n    - name: Install xrdp\n      apt: name=xrdp update_cache=yes state=latest\n\n    - name: Wait for Jenkins to start up before proceeding.\n      shell: "curl -D - --silent --max-time 5 http://{{ ipmaster }}:8089/cli/"\n      register: result\n      until: (result.stdout.find("403 Forbidden") != -1) or (result.stdout.find("200 OK") != -1) and (result.stdout.find("Please wait while") == -1)\n      retries: "60"\n      delay: "5"\n      changed_when: false\n\n    - name: Wait for Gitlab to start up before proceeding.\n      shell: "curl -D - --silent --max-time 5 http://{{ ipmaster }}/api/v3/user"\n      register: result\n      until: (result.stdout.find("403 Forbidden") != -1) or (result.stdout.find("401 Unauthorized") != -1) and (result.stdout.find("Please wait while") == -1)\n      retries: "60"\n      delay: "5"\n      changed_when: false\n\n    - name: Wait for Sonar to start up before proceeding.\n      shell: "curl -D - --silent --max-time 5 http://{{ ipmaster }}:9000/"\n      register: result\n      until: (result.stdout.find("403 Forbidden") != -1) or (result.stdout.find("200 OK") != -1) and (result.stdout.find("Please wait while") == -1)\n      retries: "60"\n      delay: "5"\n      changed_when: false\n\n    - name: Update pluguin Jenkins and Proyect Gitlab\n      shell: ''sh {{jenkinsnode}}/ejecutar.sh >> detail.txt''\n\n    - copy: dest=/home/{{ item.name }}/{{ userproyect }} content=''@cuentasUsuarioProyect@'' mode=0755\n      with_items: accounts\n\n    - name: Clone student repository\n      shell: ''sh /home/{{ item.name }}/{{ userproyect }}''\n      with_items: accounts\n\n    - name: Modify $HOME permissions student repository\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700 recurse=yes\n      with_items: accounts\n\n    - name: Finish 0f412483458\n      shell: ''echo "Finish Despliegue"''\n@end\n)\n\ndeploy central 1', 'java', 1, 'true', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(12, 'Receta Java multiple', 'Esta receta es una receta base para 1 maquina central y N maquinas alumnos', '@puertos@\nnetwork privada ()\n@configuracion@\n\nconfigure central (\n@begin\n---\n  - vars:\n      @cuentas@\n      home: /home/ubuntu/\n      baseurl: https://master-class:master-password@bitbucket.org/phantro/base-java.git\n      ipmaster: localhost\n      jenkinsnode: /home/ubuntu/node-jenkins\n      jenkinsnodeurl: https://master-class:master-password@bitbucket.org/phantro/node-jenkins.git\n      jenkinsserver: https://master-class:master-password@bitbucket.org/phantro/jenkins-server.git\n      jenkins: /home/ubuntu/jenkins-server\n      userproyect: proyect-user.sh\n\n    tasks:\n    - name: Install Git 0f485338872\n      apt: name=git update_cache=yes state=latest\n\n    - name: Install Curl\n      apt: name=curl update_cache=yes state=latest\n\n    - name: Update repository Node.js\n      shell: ''curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -''\n\n    - name: Install Node.js\n      apt: name=nodejs update_cache=yes state=latest\n\n    - name: Install Dependency Node.js\n      apt: name=build-essential update_cache=yes state=latest\n\n    - name: Create user accounts student\n      user: name={{ item.name }} password={{ item.pw }} shell=/bin/bash\n      with_items: accounts\n\n    - name: Modify $HOME permissions student\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700\n      with_items: accounts\n\n    - name: Create user admin\n      user: name={{ item.name }} password={{ item.pw }} shell=/bin/bash\n      with_items: admin\n\n    - name: Modify $HOME permissions admin\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700\n      with_items: admin\n\n    - lineinfile: dest=/etc/ssh/sshd_config regexp="PasswordAuthentication no" line="PasswordAuthentication no" state=absent\n    - lineinfile: dest=/etc/ssh/sshd_config regexp="PasswordAuthentication yes" line="PasswordAuthentication yes" state=present\n    - service: name=ssh state=restarted\n\n    - name: Add sudo admin\n      shell: ''adduser {{ item.name }} sudo''\n      with_items: admin\n\n    - name: Install Openssh\n      apt: name=openssh-server update_cache=yes state=latest\n    - name: Install Certificates\n      apt: name=ca-certificates update_cache=yes state=latest\n    - name: Update repository sh\n      shell: ''curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash''\n    - name: Install Gitlab\n      apt: name=gitlab-ce update_cache=yes state=latest\n\n    - name: Initial Gitlab\n      shell: ''gitlab-ctl reconfigure''\n\n    - name: App | Cloning repos + backup proyect\n      git: repo={{ jenkinsnodeurl }}\n           dest={{ item.dest }}\n           accept_hostkey=yes\n           force=yes\n           recursive=no\n      with_items:\n        -\n          dest: "{{ jenkinsnode }}"\n          repo: PrimaryRepo\n\n    - copy: dest={{ jenkinsnode }}/user.json content=''@cuentasUsuarioJson@''\n\n    - copy: dest={{ jenkinsnode }}/repository.json content=''@cuentasGit@''\n\n    - name: Add repo for java 8 0f168424895\n      apt_repository: repo=''ppa:openjdk-r/ppa'' state=present\n\n    - name: Install java 8\n      apt: name=openjdk-8-jdk state=latest update-cache=yes force=yes\n      sudo: yes\n\n    - lineinfile: dest=/etc/bash.bashrc regexp="export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" line="export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" create=yes\n\n    - name: App | Cloning repos + submodules + jenkins 0f452458482\n      git: repo={{jenkinsserver}}\n           dest={{ item.dest }}\n           accept_hostkey=yes\n           force=yes\n           recursive=no\n      with_items:\n        -\n          dest: "{{ jenkins }}"\n          repo: PrimaryRepo\n\n    - name: Download Maven\n      get_url: url=http://archive.apache.org/dist/maven/binaries/apache-maven-3.0.4-bin.tar.gz dest={{home}}\n\n    - name: Unarchive maven\n      unarchive: src={{home}}apache-maven-3.0.4-bin.tar.gz dest={{home}} copy=no\n\n    - name: Delete Apache.tar.gz\n      file: path={{home}}apache-maven-3.0.4-bin.tar.gz state=absent recurse=no\n\n    - command: mv {{home}}apache-maven-3.0.4 /usr/local\n\n    - name: Run Maven\n      shell: ''sudo ln -s /usr/local/apache-maven-3.0.4/bin/mvn /usr/bin/mvn''\n\n    - name: Download Sonar\n      get_url: url=https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-4.5.7.zip dest={{home}}\n\n    - name: Install unzip\n      apt: pkg=unzip state=latest update_cache=yes\n\n    - name: Unarchive Sonar\n      unarchive: src={{home}}sonarqube-4.5.7.zip dest={{home}} copy=no\n\n    - name: Delete Sonar.zip\n      file: path={{home}}sonarqube-4.5.7.zip state=absent recurse=no\n\n    - name: Run Sonar\n      shell: ''cd {{home}}sonarqube-4.5.7 && bin/linux-x86-64/sonar.sh console &''\n\n    - command: /bin/sleep 180\n\n    - name: Run Jenkins\n      shell: ''{{jenkins}}/jenkins.sh start''\n\n    - command: /bin/sleep 180\n\n    - name: Install codeblocks\n      apt: name=codeblocks update_cache=yes state=latest\n\n    - name: Install lxde\n      apt: name=lxde update_cache=yes state=latest\n\n    - name: Run lxdm\n      shell: ''start lxdm''\n\n    - name: Install xrdp\n      apt: name=xrdp update_cache=yes state=latest\n\n    - name: Wait for Jenkins to start up before proceeding.\n      shell: "curl -D - --silent --max-time 5 http://{{ ipmaster }}:8089/cli/"\n      register: result\n      until: (result.stdout.find("403 Forbidden") != -1) or (result.stdout.find("200 OK") != -1) and (result.stdout.find("Please wait while") == -1)\n      retries: "60"\n      delay: "5"\n      changed_when: false\n\n    - name: Wait for Gitlab to start up before proceeding.\n      shell: "curl -D - --silent --max-time 5 http://{{ ipmaster }}/api/v3/user"\n      register: result\n      until: (result.stdout.find("403 Forbidden") != -1) or (result.stdout.find("401 Unauthorized") != -1) and (result.stdout.find("Please wait while") == -1)\n      retries: "60"\n      delay: "5"\n      changed_when: false\n\n    - name: Wait for Sonar to start up before proceeding.\n      shell: "curl -D - --silent --max-time 5 http://{{ ipmaster }}:9000/"\n      register: result\n      until: (result.stdout.find("403 Forbidden") != -1) or (result.stdout.find("200 OK") != -1) and (result.stdout.find("Please wait while") == -1)\n      retries: "60"\n      delay: "5"\n      changed_when: false\n\n    - name: Update pluguin Jenkins and Proyect Gitlab\n      shell: ''sh {{jenkinsnode}}/ejecutar.sh >> detail.txt''\n\n    - copy: dest=/home/{{ item.name }}/{{ userproyect }} content=''@cuentasUsuarioProyect@'' mode=0755\n      with_items: accounts\n\n    - name: Clone student repository\n      shell: ''sh /home/{{ item.name }}/{{ userproyect }}''\n      with_items: accounts\n\n    - name: Modify $HOME permissions student repository\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700 recurse=yes\n      with_items: accounts\n\n@end\n)\n\nconfigure mv (\n@begin\n---\n  - vars:\n      @cuentas@\n      ipmaster: central-priv\n      userproyect : proyect-user.sh\n    tasks:\n    - name: Install Git\n      apt: name=git update_cache=yes state=latest\n\n    - name: Create user accounts student\n      user: name={{ item.name }} password={{ item.pw }} shell=/bin/bash\n      with_items: accounts\n\n    - name: Modify $HOME permissions student\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700\n      with_items: accounts\n\n    - name: Create user admin\n      user: name={{ item.name }} password={{ item.pw }} shell=/bin/bash\n      with_items: admin\n\n    - name: Modify $HOME permissions admin\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700\n      with_items: admin\n\n    - lineinfile: dest=/etc/ssh/sshd_config regexp="PasswordAuthentication no" line="PasswordAuthentication no" state=absent\n    - lineinfile: dest=/etc/ssh/sshd_config regexp="PasswordAuthentication yes" line="PasswordAuthentication yes" state=present\n    - service: name=ssh state=restarted\n\n    - name: Add sudo admin\n      shell: ''adduser {{ item.name }} sudo''\n      with_items: admin\n\n    - name: Add repo for java 8 0f168424895\n      apt_repository: repo=''ppa:openjdk-r/ppa'' state=present\n\n    - name: Install java 8\n      apt: name=openjdk-8-jdk state=latest update-cache=yes force=yes\n      sudo: yes\n\n    - lineinfile: dest=/etc/bash.bashrc regexp="export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" line="export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" create=yes\n\n    - copy: dest=/home/{{ item.name }}/{{ userproyect }} content=''@cuentasUsuarioProyect@'' mode=0755\n      with_items: accounts\n\n    - name: Clone student repository\n      shell: ''sh /home/{{ item.name }}/{{ userproyect }}''\n      with_items: accounts\n\n    - name: Modify $HOME permissions student repository\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700 recurse=yes\n      with_items: accounts\n\n    - name: Install codeblocks\n      apt: name=codeblocks update_cache=yes state=latest\n\n    - name: Install lxde\n      apt: name=lxde update_cache=yes state=latest\n\n    - name: Run lxdm\n      shell: ''start lxdm''\n\n    - name: Install xrdp\n      apt: name=xrdp update_cache=yes state=latest\n\n    - name: Finish 0f412483458\n      shell: ''echo "Finish Despliegue"''\n@end\n)\n\ndeploy central 1\ndeploy mv @countStudent@\n\ncontextualize (\n    system central configure central step 1\n    system mv configure mv step 2\n)', 'java', 2, 'true', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(14, 'Receta C Central', 'Esta receta es una receta base para 1 maquina central', '@puertos@\nnetwork privada ()\n@configuracion@\n\nconfigure central (\n@begin\n---\n  - vars:\n      @cuentas@\n      ipmaster: localhost\n      jenkinsnode: /home/ubuntu/node-jenkins\n      jenkinsnodeurl: https://master-class:master-password@bitbucket.org/phantro/node-jenkins-c.git\n      jenkinsserver: https://master-class:master-password@bitbucket.org/phantro/jenkins-server.git\n      jenkins: /home/ubuntu/jenkins-server\n      userproyect: proyect-user.sh\n\n    tasks:\n    - name: Install Git 0f485338872\n      apt: name=git update_cache=yes state=latest\n\n    - name: Install Curl\n      apt: name=curl update_cache=yes state=latest\n\n    - name: Update repository Node.js\n      shell: ''curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -''\n\n    - name: Install Node.js\n      apt: name=nodejs update_cache=yes state=latest\n\n    - name: Install Dependency Node.js\n      apt: name=build-essential update_cache=yes state=latest\n\n    - name: Create user accounts student\n      user: name={{ item.name }} password={{ item.pw }} shell=/bin/bash\n      with_items: accounts\n\n    - name: Modify $HOME permissions student\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700\n      with_items: accounts\n\n    - name: Create user admin\n      user: name={{ item.name }} password={{ item.pw }} shell=/bin/bash\n      with_items: admin\n\n    - name: Modify $HOME permissions admin\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700\n      with_items: admin\n\n    - lineinfile: dest=/etc/ssh/sshd_config regexp="PasswordAuthentication no" line="PasswordAuthentication no" state=absent\n    - lineinfile: dest=/etc/ssh/sshd_config regexp="PasswordAuthentication yes" line="PasswordAuthentication yes" state=present\n    - service: name=ssh state=restarted\n\n    - name: Add sudo admin\n      shell: ''adduser {{ item.name }} sudo''\n      with_items: admin\n\n    - name: Install Openssh\n      apt: name=openssh-server update_cache=yes state=latest\n    - name: Install Certificates\n      apt: name=ca-certificates update_cache=yes state=latest\n    - name: Update repository sh\n      shell: ''curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash''\n    - name: Install Gitlab\n      apt: name=gitlab-ce update_cache=yes state=latest\n\n    - name: Initial Gitlab\n      shell: ''gitlab-ctl reconfigure''\n\n    - name: App | Cloning repos + backup proyect\n      git: repo={{ jenkinsnodeurl }}\n           dest={{ item.dest }}\n           accept_hostkey=yes\n           force=yes\n           recursive=no\n      with_items:\n        -\n          dest: "{{ jenkinsnode }}"\n          repo: PrimaryRepo\n\n    - copy: dest={{ jenkinsnode }}/user.json content=''@cuentasUsuarioJson@''\n\n    - copy: dest={{ jenkinsnode }}/repository.json content=''@cuentasGit@''\n\n    - name: Add repo for java 8 0f168424895\n      apt_repository: repo=''ppa:openjdk-r/ppa'' state=present\n\n    - name: Install java 8\n      apt: name=openjdk-8-jdk state=latest update-cache=yes force=yes\n      sudo: yes\n\n    - lineinfile: dest=/etc/bash.bashrc regexp="export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" line="export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" create=yes\n\n    - name: App | Cloning repos + submodules + jenkins 0f452458482\n      git: repo={{jenkinsserver}}\n           dest={{ item.dest }}\n           accept_hostkey=yes\n           force=yes\n           recursive=no\n      with_items:\n        -\n          dest: "{{ jenkins }}"\n          repo: PrimaryRepo\n\n    - name: Install unzip\n      apt: pkg=unzip state=latest update_cache=yes\n\n    - name: Run Jenkins\n      shell: ''{{jenkins}}/jenkins.sh start''\n\n    - command: /bin/sleep 180\n\n    - name: Install codeblocks\n      apt: name=codeblocks update_cache=yes state=latest\n\n    - name: Install lxde\n      apt: name=lxde update_cache=yes state=latest\n\n    - name: Run lxdm\n      shell: ''start lxdm''\n\n    - name: Install xrdp\n      apt: name=xrdp update_cache=yes state=latest\n\n    - name: Wait for Jenkins to start up before proceeding.\n      shell: "curl -D - --silent --max-time 5 http://{{ ipmaster }}:8089/cli/"\n      register: result\n      until: (result.stdout.find("403 Forbidden") != -1) or (result.stdout.find("200 OK") != -1) and (result.stdout.find("Please wait while") == -1)\n      retries: "60"\n      delay: "5"\n      changed_when: false\n\n    - name: Wait for Gitlab to start up before proceeding.\n      shell: "curl -D - --silent --max-time 5 http://{{ ipmaster }}/api/v3/user"\n      register: result\n      until: (result.stdout.find("403 Forbidden") != -1) or (result.stdout.find("401 Unauthorized") != -1) and (result.stdout.find("Please wait while") == -1)\n      retries: "60"\n      delay: "5"\n      changed_when: false\n\n    - name: Update pluguin Jenkins and Proyect Gitlab\n      shell: ''sh {{jenkinsnode}}/ejecutar.sh >> detail.txt''\n\n    - copy: dest=/home/{{ item.name }}/{{ userproyect }} content=''@cuentasUsuarioProyect@'' mode=0755\n      with_items: accounts\n\n    - name: Clone student repository\n      shell: ''sh /home/{{ item.name }}/{{ userproyect }}''\n      with_items: accounts\n\n    - name: Modify $HOME permissions student repository\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700 recurse=yes\n      with_items: accounts\n\n    - name: Finish 0f412483458\n      shell: ''echo "Finish Despliegue"''\n@end\n)\n\ndeploy central 1', 'c', 1, 'true', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(15, 'Receta C multiple', 'Esta receta es una receta base para 1 maquina central y N maquinas alumnos', '@puertos@\nnetwork privada ()\n@configuracion@\n\nconfigure central (\n@begin\n---\n  - vars:\n      @cuentas@\n      ipmaster: localhost\n      jenkinsnode: /home/ubuntu/node-jenkins\n      jenkinsnodeurl: https://master-class:master-password@bitbucket.org/phantro/node-jenkins-c.git\n      jenkinsserver: https://master-class:master-password@bitbucket.org/phantro/jenkins-server.git\n      jenkins: /home/ubuntu/jenkins-server\n      userproyect: proyect-user.sh\n\n    tasks:\n    - name: Install Git 0f485338872\n      apt: name=git update_cache=yes state=latest\n\n    - name: Install Curl\n      apt: name=curl update_cache=yes state=latest\n\n    - name: Update repository Node.js\n      shell: ''curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -''\n\n    - name: Install Node.js\n      apt: name=nodejs update_cache=yes state=latest\n\n    - name: Install Dependency Node.js\n      apt: name=build-essential update_cache=yes state=latest\n\n    - name: Create user accounts student\n      user: name={{ item.name }} password={{ item.pw }} shell=/bin/bash\n      with_items: accounts\n\n    - name: Modify $HOME permissions student\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700\n      with_items: accounts\n\n    - name: Create user admin\n      user: name={{ item.name }} password={{ item.pw }} shell=/bin/bash\n      with_items: admin\n\n    - name: Modify $HOME permissions admin\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700\n      with_items: admin\n\n    - lineinfile: dest=/etc/ssh/sshd_config regexp="PasswordAuthentication no" line="PasswordAuthentication no" state=absent\n    - lineinfile: dest=/etc/ssh/sshd_config regexp="PasswordAuthentication yes" line="PasswordAuthentication yes" state=present\n    - service: name=ssh state=restarted\n\n    - name: Add sudo admin\n      shell: ''adduser {{ item.name }} sudo''\n      with_items: admin\n\n    - name: Install Openssh\n      apt: name=openssh-server update_cache=yes state=latest\n    - name: Install Certificates\n      apt: name=ca-certificates update_cache=yes state=latest\n    - name: Update repository sh\n      shell: ''curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash''\n    - name: Install Gitlab\n      apt: name=gitlab-ce update_cache=yes state=latest\n\n    - name: Initial Gitlab\n      shell: ''gitlab-ctl reconfigure''\n\n    - name: App | Cloning repos + backup proyect\n      git: repo={{ jenkinsnodeurl }}\n           dest={{ item.dest }}\n           accept_hostkey=yes\n           force=yes\n           recursive=no\n      with_items:\n        -\n          dest: "{{ jenkinsnode }}"\n          repo: PrimaryRepo\n\n    - copy: dest={{ jenkinsnode }}/user.json content=''@cuentasUsuarioJson@''\n\n    - copy: dest={{ jenkinsnode }}/repository.json content=''@cuentasGit@''\n\n    - name: Add repo for java 8 0f168424895\n      apt_repository: repo=''ppa:openjdk-r/ppa'' state=present\n\n    - name: Install java 8\n      apt: name=openjdk-8-jdk state=latest update-cache=yes force=yes\n      sudo: yes\n\n    - lineinfile: dest=/etc/bash.bashrc regexp="export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" line="export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" create=yes\n\n    - name: App | Cloning repos + submodules + jenkins 0f452458482\n      git: repo={{jenkinsserver}}\n           dest={{ item.dest }}\n           accept_hostkey=yes\n           force=yes\n           recursive=no\n      with_items:\n        -\n          dest: "{{ jenkins }}"\n          repo: PrimaryRepo\n\n    - name: Install unzip\n      apt: pkg=unzip state=latest update_cache=yes\n\n    - name: Run Jenkins\n      shell: ''{{jenkins}}/jenkins.sh start''\n\n    - command: /bin/sleep 180\n\n    - name: Install codeblocks\n      apt: name=codeblocks update_cache=yes state=latest\n\n    - name: Install lxde\n      apt: name=lxde update_cache=yes state=latest\n\n    - name: Run lxdm\n      shell: ''start lxdm''\n\n    - name: Install xrdp\n      apt: name=xrdp update_cache=yes state=latest\n\n    - name: Wait for Jenkins to start up before proceeding.\n      shell: "curl -D - --silent --max-time 5 http://{{ ipmaster }}:8089/cli/"\n      register: result\n      until: (result.stdout.find("403 Forbidden") != -1) or (result.stdout.find("200 OK") != -1) and (result.stdout.find("Please wait while") == -1)\n      retries: "60"\n      delay: "5"\n      changed_when: false\n\n    - name: Wait for Gitlab to start up before proceeding.\n      shell: "curl -D - --silent --max-time 5 http://{{ ipmaster }}/api/v3/user"\n      register: result\n      until: (result.stdout.find("403 Forbidden") != -1) or (result.stdout.find("401 Unauthorized") != -1) and (result.stdout.find("Please wait while") == -1)\n      retries: "60"\n      delay: "5"\n      changed_when: false\n\n    - name: Update pluguin Jenkins and Proyect Gitlab\n      shell: ''sh {{jenkinsnode}}/ejecutar.sh >> detail.txt''\n\n    - copy: dest=/home/{{ item.name }}/{{ userproyect }} content=''@cuentasUsuarioProyect@'' mode=0755\n      with_items: accounts\n\n    - name: Clone student repository\n      shell: ''sh /home/{{ item.name }}/{{ userproyect }}''\n      with_items: accounts\n\n    - name: Modify $HOME permissions student repository\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700 recurse=yes\n      with_items: accounts\n\n@end\n)\n\nconfigure mv (\n@begin\n---\n  - vars:\n      @cuentas@\n      ipmaster: central-priv\n      userproyect : proyect-user.sh\n    tasks:\n    - name: Install Git\n      apt: name=git update_cache=yes state=latest\n\n    - name: Create user accounts student\n      user: name={{ item.name }} password={{ item.pw }} shell=/bin/bash\n      with_items: accounts\n\n    - name: Modify $HOME permissions student\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700\n      with_items: accounts\n\n    - name: Create user admin\n      user: name={{ item.name }} password={{ item.pw }} shell=/bin/bash\n      with_items: admin\n\n    - name: Modify $HOME permissions admin\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700\n      with_items: admin\n\n    - lineinfile: dest=/etc/ssh/sshd_config regexp="PasswordAuthentication no" line="PasswordAuthentication no" state=absent\n    - lineinfile: dest=/etc/ssh/sshd_config regexp="PasswordAuthentication yes" line="PasswordAuthentication yes" state=present\n    - service: name=ssh state=restarted\n\n    - name: Add sudo admin\n      shell: ''adduser {{ item.name }} sudo''\n      with_items: admin\n\n    - name: Add repo for java 8 0f168424895\n      apt_repository: repo=''ppa:openjdk-r/ppa'' state=present\n\n    - name: Install java 8\n      apt: name=openjdk-8-jdk state=latest update-cache=yes force=yes\n      sudo: yes\n\n    - lineinfile: dest=/etc/bash.bashrc regexp="export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" line="export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" create=yes\n\n    - copy: dest=/home/{{ item.name }}/{{ userproyect }} content=''@cuentasUsuarioProyect@'' mode=0755\n      with_items: accounts\n\n    - name: Clone student repository\n      shell: ''sh /home/{{ item.name }}/{{ userproyect }}''\n      with_items: accounts\n\n    - name: Modify $HOME permissions student repository\n      file: path=/home/{{ item.name }} state=directory owner={{ item.name }} group={{ item.name }} mode=0700 recurse=yes\n      with_items: accounts\n\n    - name: Install codeblocks\n      apt: name=codeblocks update_cache=yes state=latest\n\n    - name: Install lxde\n      apt: name=lxde update_cache=yes state=latest\n\n    - name: Run lxdm\n      shell: ''start lxdm''\n\n    - name: Install xrdp\n      apt: name=xrdp update_cache=yes state=latest\n\n    - name: Finish 0f412483458\n      shell: ''echo "Finish Despliegue"''\n@end\n)\n\ndeploy central 1\ndeploy mv @countStudent@\n\ncontextualize (\n    system central configure central step 1\n    system mv configure mv step 2\n)', 'c', 2, 'true', '0000-00-00 00:00:00', '0000-00-00 00:00:00');

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `radls`
--
ALTER TABLE `radls`
  ADD CONSTRAINT `radls_ibfk_1` FOREIGN KEY (`id_recipe`) REFERENCES `recipe` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
